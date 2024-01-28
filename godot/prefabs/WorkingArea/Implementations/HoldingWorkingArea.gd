class_name HoldingWorkingArea
extends WorkingArea

@export var duration : float
@export var slider : Slider3D
@export var object_position : Node3D
@export var result_position : Node3D
@export var has_turn_off_object : bool

var elapsed_time : float
var is_processing : bool

func _can_put_intern(pickable_object : Node3D) -> bool:
	return _is_valid_pickable(pickable_object)
	
func put(pickable_object : Node3D):
	if(pickable_object == null):
		return
	
	isInUse = true
	pickable_object_in_use = pickable_object
	pickable_object_in_use.reparent(self)
	pickable_object.position = object_position.position
	
	if has_turn_off_object:
		pickable_object_in_use.hide()
		
	elapsed_time = 0
	is_processing = true
	_put_intern_holding()
	
func _put_intern_holding():
	print("")

func can_pick() -> bool:
	return isInUse && !is_processing
	
func can_be_processed() -> bool:
	return isInUse && is_processing

func process(step : float):
	elapsed_time += step
	
	var slider_value : float 
	slider_value = inverse_lerp(0, duration, elapsed_time)
	slider_value = clampf(slider_value, 0, elapsed_time)
	slider.set_value(slider_value)
	
	if(elapsed_time >= duration):
		is_processing = false
		pickable_object_in_use.position = result_position.position
		done()
	
