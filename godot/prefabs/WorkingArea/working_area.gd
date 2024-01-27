class_name WorkingArea
extends Node3D

@export var object_type := ObjectType.EnumObjectType.unknown
@export var area_name := "Working Area"
@export var action_name := "Do Action"

var isInUse : bool
var pickable_object_in_use : PickableObject

func can_put(pickable_object : Node3D) -> bool:
	if(isInUse):
		return false
		
	return _can_put_intern(pickable_object)

func _can_put_intern(pickable_object : Node3D) -> bool:
	return true
	
func _is_valid_pickable(pickable_object : Node3D) -> bool:
	if(pickable_object_in_use != null):
		return pickable_object.object_type == pickable_object_in_use.object_type
	else:
		return true

func put(pickable_object : Node3D):
	pickable_object_in_use = pickable_object
	_put_intern(pickable_object)

func _put_intern(pickable_object : Node3D):
	pickable_object_in_use = pickable_object
	
func can_pick() -> bool:
	print("needing implementation")
	return true
	
func pick() -> PickableObject:
	return pickable_object_in_use
	
func can_be_processed() -> bool:
	print("needing implementation")
	return true
	
func process(step : float):
	print("needing implementation")
	
func _on_interaction_area_closest_object_changed(prev: PickableObject, new: PickableObject):
	if(new and not new.is_picked and can_put(new)):
		put(new)

func _on_body_entered(body):
	print(body)
	var player = body as PlayerCharacter
	if player and player.current_working_area == null: 
		player.current_working_area = self

func _on_body_exited(body):
	print(body)
	var player = body as PlayerCharacter
	if player and player.current_working_area == self: 
		player.current_working_area = null
