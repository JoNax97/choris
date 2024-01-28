extends Node3D

const client_template = preload("res://prefabs/client/client.tscn")

@export var markers: Array[Node3D]
@export var leave_pos: Node3D

var clients: Array[Client]
var current_client: Client

# Called when the node enters the scene tree for the first time.
func _ready():
	for marker in markers:
		var client = client_template.instantiate() as Client
		add_child(client)
		clients.push_back(client)
		client.global_position = marker.global_position
		client.idle_chatter()
	
	_next_client()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _next_client():
	if clients.is_empty():
		return
		
	current_client = clients[0]
	current_client.ask_for_object()
	
	await current_client.order_received
	
	current_client.leave(leave_pos)
	clients.pop_front()
	
	var client_idx = 0
	for client in clients:
		await client._move_to( markers[client_idx])
		if client_idx == 0:
			_next_client()
		client_idx += 1

