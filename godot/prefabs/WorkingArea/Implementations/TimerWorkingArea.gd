class_name TimerWorkingArea
extends HoldingWorkingArea

@export var timer : Timer

func _put_intern_holding():
	timer.wait_time = duration
	timer.start()

func process(step : float):
	print("")
	
func _on_timer_timeout():
	is_processing = false
	
func _process(delta):
	if(!is_processing):
		return
		
	var slider_value : float 
	slider_value = inverse_lerp(0, duration, abs(timer.time_left - duration))
	slider_value = clampf(slider_value, 0, elapsed_time)
	slider.value = slider_value
