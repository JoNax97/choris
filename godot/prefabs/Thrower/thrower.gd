extends Area3D

@export var throw_point : Node3D

var is_colliding_with_action_area : bool
var action_area : ActionArea

func _process(delta):
	translate(Vector3(0.01,0,0))

# Add in the character code the check if it is colliding with a ActionArea
func throw(pickable_object : PickableObject):
	if(is_colliding_with_action_area && pickable_object.object_type == action_area.object_type):
		action_area.set_object(pickable_object)
	else:
		pickable_object.position = throw_point.position

func _on_btttody_entered(body):
	is_colliding_with_action_area = body is ActionArea
	
	if(is_colliding_with_action_area):
		action_area = body as ActionArea
