extends Node3D

@export var object_data: ObjectData
@onready var timer: Timer = $AutospawnTimer
@export var direction : Vector2

@export var pickable_obj_template : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(spawn_object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func spawn_object():
	var obj = pickable_obj_template.instantiate() as Rat
	get_tree().root.add_child(obj)
	obj.global_position = self.global_position
	obj.pickable.data = object_data
	obj.set_direction(direction)
