extends Node

var devices : Array[InputDevice] = []

func _process(delta):
	pass
	
func add_device() -> int: 
	var device_idx = devices.size()
	var device = InputDevice.new()
	device.initialize(device_idx)
	devices.push_back(device)
	return device_idx


func get_movement_dir(device: int) -> Vector2: 
	return devices[device].get_vector("move_left", "move_right", "move_up", "move_down")

