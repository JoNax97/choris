extends Node3D

@export var desired_object: ObjectData

@onready var label : Label3D = $Label

func ask_for_object():
	label.text = "Gordo armame un %s, metele pata" % desired_object.name

func give_object(obj: PickableObject):
	var is_correct = desired_object.tags.equals( obj.data.tags)
	label.text = "Grasia ameo" if is_correct else "Que mierda es esto"
	obj.queue_free()
