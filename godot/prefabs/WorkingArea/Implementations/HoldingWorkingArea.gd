class_name HoldingWorkingArea
extends WorkingArea

@export var hold_duration : float
@export var slider : HSlider

var elapsed_time : float # use for update the ui
var is_processing : bool

func _can_put_intern(pickable_object : Node3D) -> bool:
	return _is_valid_pickable(pickable_object)
	
func put(pickable_object : Node3D):
	if(pickable_object == null):
		return
		
	pickable_object.reparent(self)
	pickable_object.hide()
	elapsed_time = 0
	is_processing = true
	_put_intern_holding()
	
func _put_intern_holding():
	print("")

func process(step : float):
	elapsed_time += step
	
	var slider_value : float 
	slider_value = inverse_lerp(0, hold_duration, elapsed_time)
	slider_value = clampf(slider_value, 0, elapsed_time)
	slider.value = slider_value
	
	if(elapsed_time >= hold_duration):
		is_processing = false
	
