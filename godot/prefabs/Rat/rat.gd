class_name Rat
extends Node3D

@export var pickable : PickableObject
@export var speed : float
@export var spriteframe : Node3D
@export var is_picked : bool

var direction : Vector3

func set_direction(directionToMove : Vector2):
	direction = Vector3(directionToMove.x, 0 , directionToMove.y)
	
func _process(delta):
	translate(direction * speed * delta)
	#spriteframe.ro(direction, Vector3.UP)

func pick():
	is_picked = true
	hide()

func _on_area_3d_body_entered(body):
	var player = body as PlayerCharacter
	if player and player.current_client == null: 
		player.current_rat = self

func _on_area_3d_body_exited(body):
	var player = body as PlayerCharacter
	if player and player.current_rat == self: 
		player.current_rat = null
