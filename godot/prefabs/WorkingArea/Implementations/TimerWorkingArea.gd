class_name TimerWorkingArea
extends HoldingWorkingArea

@export var timer : Timer

func _put_intern_holding():
	timer.wait_time = duration
	timer.start()

func process(step : float):
	_process(0)
	
func _on_timer_timeout():
	is_processing = false
	done()
	
func _process(delta):
	if(!is_processing):
		return
		
	var slider_value : float 
	slider_value = inverse_lerp(0, duration, abs(timer.time_left - duration))
	slider_value = clampf(slider_value, 0, duration)
	slider.set_value(slider_value)
