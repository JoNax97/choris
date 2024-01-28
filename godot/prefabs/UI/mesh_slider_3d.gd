class_name Slider3D
extends Node3D

@export var fill : Node3D

func set_value(value : float):
	value = clampf(value, 0, 1)
	fill.scale.x = value
