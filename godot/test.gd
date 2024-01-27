extends Node3D

@export var pickable : PickableObject
@export var working_area : WorkingArea

func _ready():
	working_area.put(pickable)
