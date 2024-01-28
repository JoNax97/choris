class_name PickableObject extends RigidBody3D

@onready var sprite = $Sprite3D

var data: ObjectData : set = _set_data

var is_picked

func pick(parent: Node3D):
	if is_picked:
		return
	
	is_picked = true
	reparent(parent, false)
	position = Vector3.ZERO
	freeze = true
	
func drop():
	reparent(get_tree().root, true)
	freeze = false
	await get_tree().create_timer(0.7).timeout
	is_picked = false
	
func add_tags(tags: ObjectTags):
	pass

func _set_data(d: ObjectData):
	data = d
	sprite.texture = data.sprite
