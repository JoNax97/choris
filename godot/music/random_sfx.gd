extends AudioStreamPlayer3D

@export_range(0.1, 100) var min_time = 1.0
@export_range(0.1, 100) var max_time = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		var time = randf_range(min_time, max_time)
		await get_tree().create_timer(time).timeout
		play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
