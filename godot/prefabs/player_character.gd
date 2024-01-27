extends CharacterBody3D

@export var speed = 500.0
@export var acceleration = 50.0

@onready var meshInstance : MeshInstance3D = $ModelPivot/MeshInstance3D
@onready var interaction_area : InteractionArea = $InteractionArea
@onready var audio_stream_player_3d : AudioStreamPlayer3D = $AudioStreamPlayer3D


var player_idx : int

const player_colors = [Color.CRIMSON, Color.DODGER_BLUE, Color.DARK_ORANGE, Color.CHARTREUSE]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player_idx = InputManager.add_device()
	var mat_instance = meshInstance.material_override.duplicate()
	meshInstance.material_override = mat_instance
	mat_instance.albedo_color = player_colors[player_idx]


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = InputManager.get_movement_dir(player_idx)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() 
	var frame_accel = acceleration * delta
	
	if direction:
		var frame_speed = move_toward(velocity.length(), speed * delta, frame_accel)
		velocity = velocity.move_toward(direction * speed * delta, frame_accel * 3)
	else:
		var frame_speed = move_toward(velocity.length(), 0, frame_accel)
		velocity = velocity.move_toward(Vector3.ZERO, frame_accel)

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
	
	if InputManager.is_action_button_pressed(player_idx):
		var obj = interaction_area.closest_object
		if obj:
			obj.reparent($PickedObjectPivot, false)
			obj.position = Vector3.ZERO
			obj.freeze = true
			if not audio_stream_player_3d.playing:
				audio_stream_player_3d.play()

func _on_interaction_area_closest_object_changed(prev, new):
	if prev: 
		prev.scale = Vector3.ONE
	if new: 
		new.scale = Vector3.ONE * 1.2
