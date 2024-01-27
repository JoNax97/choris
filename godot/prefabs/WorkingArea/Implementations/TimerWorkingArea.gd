class_name TimerWorkingArea
extends HoldingWorkingArea

@export var timer : Timer

func _put_intern_holding():
	timer.start()

#add signal

func process(step : float):
	print("")
	
