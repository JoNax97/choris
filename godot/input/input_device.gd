class_name InputDevice extends Node

var _device : int
var _suffix : String

func initialize(device: int):
	if device == -1:
		push_error("Cannot set up DeviceInput for all devices")
		return
	
	_device = device
	_suffix = "_device_%d" % device
	
	# Find all controller inputs, and add new actions that are device-specific
	for base_action in InputMap.get_actions():
		# Ensure the action hasn't already been added in another scene
		if not base_action.ends_with(_suffix):
			_duplicate_action(base_action)

func _duplicate_action(base_action: String):
	var new_action = _add_suffix(base_action)
	for event in InputMap.action_get_events(base_action):
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			if not InputMap.has_action(new_action):
				var base_deadzone = InputMap.action_get_deadzone(base_action)
				InputMap.add_action(new_action, base_deadzone)
			
			var new_event = event.duplicate()
			new_event.device = _device
			
			InputMap.action_add_event(new_action, new_event)

func _add_suffix(action) -> StringName:
	return action + _suffix

func is_action_just_pressed(action: String) -> bool:
	return Input.is_action_just_pressed(_add_suffix(action))

func get_action_strength(action: String) -> float:
	return Input.get_action_strength( _add_suffix(action))
	
func get_vector(negative_x: StringName, positive_x: StringName, negative_y: StringName, positive_y: StringName) -> Vector2:
	return Input.get_vector(_add_suffix(negative_x), _add_suffix(positive_x), _add_suffix(negative_y), _add_suffix(positive_y))
