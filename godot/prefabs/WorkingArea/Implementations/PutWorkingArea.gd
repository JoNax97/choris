class_name PuttableWorkingArea
extends WorkingArea

@export var object_position : Node3D

func _can_put_intern(pickable_object : Node3D) -> bool:
	return _is_valid_pickable(pickable_object)
	
func _put_intern(pickable_object : Node3D):
	pickable_object.reparent(self)
	pickable_object.position = object_position.position
