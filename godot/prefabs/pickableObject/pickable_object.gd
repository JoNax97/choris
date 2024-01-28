class_name PickableObject extends RigidBody3D

signal data_changed

@onready var sprite = $Sprite3D

var data: ObjectData : set = _set_data

var is_picked

func pick(parent: Node3D, force = false):
	if is_picked && !force:
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
	
func modify_tags(tags_to_add: ObjectTags, tags_to_remove: ObjectTags):
	var combined = data.tags.combine(tags_to_add, tags_to_remove)
	data = ObjectDataSource.get_data_for_tags(combined)
	
func _set_data(d: ObjectData):
	data = d
	sprite.texture = data.sprite
	data_changed.emit()
