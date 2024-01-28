class_name Client extends Node3D

@export var desired_object: ObjectData
@export var phrase_override := ""

@onready var label : Label3D = $Label
@onready var object_pivot: Node3D = $Pivot

func _ready():
	ask_for_object()

func ask_for_object():
	if not phrase_override.is_empty():
		label.text = phrase_override
	else:
		label.text = "Gordo armame un %s, metele pata" % desired_object.name

func give_object(obj: PickableObject):
	obj.pick(object_pivot, true)
	var is_correct = desired_object.tags.equals( obj.data.tags)
	label.text = "Grasia ameo" if is_correct else "Que mierda es esto"
	await get_tree().create_timer(0.7).timeout
	obj.queue_free()
	await get_tree().create_timer(0.7).timeout
	ask_for_object()

func _on_body_entered(body):
	var player = body as PlayerCharacter
	if player and player.current_client == null: 
		player.current_client = self

func _on_body_exited(body):
	var player = body as PlayerCharacter
	if player and player.current_client == self: 
		player.current_client = null
