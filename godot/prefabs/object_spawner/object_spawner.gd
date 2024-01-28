extends Node3D

@export var object_data: ObjectData

@onready var timer: Timer = $AutospawnTimer

var pickable_obj_template : PackedScene = preload("res://prefabs/pickableObject/pickable_object.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(spawn_object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func spawn_object():
	var obj = pickable_obj_template.instantiate() as PickableObject
	get_tree().root.add_child(obj)
	obj.global_position = self.global_position
	obj.data = object_data
