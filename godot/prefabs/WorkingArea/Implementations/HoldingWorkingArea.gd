class_name HoldingWorkingArea
extends WorkingArea

@export var hold_duration : float

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
	
	if(elapsed_time >= hold_duration):
		is_processing = false
	
