class_name PlayerCharacter extends CharacterBody3D

@export var speed = 500.0
@export var acceleration = 50.0

@onready var sprite : MeshInstance3D = $ModelPivot/MeshInstance3D
@onready var interaction_area : InteractionArea = $InteractionArea
@onready var label : Label3D = $Label

var current_working_area : WorkingArea
var picked_object: PickableObject

var player_idx : int

const player_colors = [Color.CRIMSON, Color.DODGER_BLUE, Color.DARK_ORANGE, Color.CHARTREUSE]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player_idx = InputManager.add_device()
	var mat_instance = sprite.material_override.duplicate()
	sprite.material_override = mat_instance
	mat_instance.set_shader_parameter("replacement_color", player_colors[player_idx])
	%PlayerPhantomCamera3D.append_follow_group_node(self)

func _physics_process(delta):

	_handle_movement(delta)
	_handle_interaction_prompt()
	_handle_interaction()

func _handle_movement(delta):
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
	
func _handle_interaction_prompt():
	var text = ""
	
	if current_working_area:
		text += current_working_area.area_name
		if picked_object and current_working_area.can_put(picked_object):
			text += ": Poner %s" % picked_object.object_name
		else: if not picked_object and current_working_area.can_pick():
			text += ": Agarrar %s" % current_working_area.pickable_object_in_use
		else: if current_working_area.can_process():
			text += ": %s" % current_working_area.action_name
	else:
		text = "NO AREA"
	
	label.text = text

func _handle_interaction():
	if not InputManager.is_action_button_pressed(player_idx):
		return
	
	if current_working_area:
		if picked_object and current_working_area.can_put(picked_object):
			current_working_area.put(picked_object)
			picked_object = null
		
		else: if not picked_object and current_working_area.can_pick():
			picked_object = current_working_area.pick()
			picked_object.pick($PickedObjectPivot)

		else: if current_working_area.can_process():
			current_working_area.process(0.1)
		
	if picked_object:
		picked_object.drop()
		picked_object = null
		return
	
	var obj = interaction_area.closest_object
	if obj and not obj.is_picked:
		picked_object = obj
		obj.pick($PickedObjectPivot)

func _on_interaction_area_closest_object_changed(prev, new):
	if picked_object:
		return
	
	if prev: 
		prev.scale = Vector3.ONE
	if new and not new.is_picked: 
		new.scale = Vector3.ONE * 1.2
		
func pick_object():
	picked_object.repa
	
