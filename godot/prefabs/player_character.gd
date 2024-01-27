extends CharacterBody3D

@export var speed = 500.0
@export var acceleration = 30.0

var player_idx : int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	player_idx = InputManager.add_device()

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = InputManager.get_movement_dir(player_idx)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() 
	var frame_accel = acceleration * delta
	print(frame_accel)
	
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
