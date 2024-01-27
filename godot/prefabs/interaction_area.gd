class_name InteractionArea extends Node3D

signal closest_object_changed(prev: PickableObject, new: PickableObject)

var objects : Array[PickableObject] = []
var closest_object: PickableObject

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var new_closest = null
	for obj in objects:
		if new_closest == null || _dist(new_closest) > _dist(obj):
			new_closest = obj
	
	if closest_object != new_closest:
		closest_object_changed.emit(closest_object, new_closest)
		closest_object = new_closest

func _on_body_entered(body):
	if body is PickableObject:
		objects.push_back(body)

func _on_body_exited(body):
	if body is PickableObject:
		var idx = objects.find(body);
		if idx >= 0:
			objects.remove_at(idx)

func _dist(obj: Node3D):
	return global_position.distance_squared_to(obj.global_position)
