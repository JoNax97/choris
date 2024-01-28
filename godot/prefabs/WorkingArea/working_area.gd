class_name WorkingArea
extends Node3D

@export var allowed_tags := ObjectTags.new()
@export var added_tags := ObjectTags.new()
@export var removed_tags := ObjectTags.new()
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
	return pickable_object.data.tags.includes(allowed_tags)
	if(pickable_object.data.tags.includes(allowed_tags)):
		pickable_object.tag
		# compare the object tags
		#return pickable_object.object_type == pickable_object_in_use.object_type
		return false
	else:
		return true

func put(pickable_object : Node3D):
	pickable_object_in_use = pickable_object
	isInUse = true
	_put_intern(pickable_object)

func _put_intern(pickable_object : Node3D):
	pickable_object_in_use = pickable_object
	
func can_pick() -> bool:
	print("needing implementation")
	return true
	
func pick() -> PickableObject:
	var obj = pickable_object_in_use
	pickable_object_in_use = null
	isInUse = false
	_pick_intern()
	return obj
	
func _pick_intern():
	pass
	
func can_be_processed() -> bool:
	print("needing implementation")
	return true
	
func process(step : float):
	print("needing implementation")
	
func done():
	#convert pickable
	pickable_object_in_use.modify_tags(added_tags, removed_tags)
	#get new pickable
	
func _on_interaction_area_closest_object_changed(prev: PickableObject, new: PickableObject):
	if(new and not new.is_picked and can_put(new)):
		put(new)

func _on_body_entered(body):
	var player = body as PlayerCharacter
	if player and player.current_working_area == null: 
		player.current_working_area = self

func _on_body_exited(body):
	var player = body as PlayerCharacter
	if player and player.current_working_area == self: 
		player.current_working_area = null
