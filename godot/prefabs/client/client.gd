class_name Client extends Node3D

signal order_received

@export var speed := 2.5

@export var desired_object: ObjectData
@export var phrase_override := ""
@export var right_sfx: AudioStream
@export var wrong_sfx: AudioStream

@onready var label : Label3D = $Label
@onready var object_pivot: Node3D = $Pivot
@onready var sfx_player = $SfxPlayer

@export var rat: ObjectTags

var can_interact = false
var order_correct: bool

func idle_chatter():
	while true:
		await get_tree().create_timer(randf_range(2, 60)).timeout
		if can_interact: return
		label.text = phrases_idle.pick_random()
		await get_tree().create_timer(1.5).timeout
		label.text = ""

func ask_for_object():
	can_interact = true
	if not phrase_override.is_empty():
		label.text = phrase_override
	else:
		label.text = "Gordo armame un %s, metele pata" % desired_object.name

func give_object(obj: PickableObject):
	if not can_interact:
		return
	
	can_interact = false
	obj.pick(object_pivot, true)
	order_correct = desired_object.tags.equals( obj.data.tags)	
	sfx_player.stream = right_sfx if order_correct else wrong_sfx
	sfx_player.play()
	
	if obj.data.tags.includes(rat):
		label.text = "QUE ASCO LA PUTA MADRE!"
	else:
		label.text = responses_right.pick_random() if order_correct else responses_wrong.pick_random()
	await get_tree().create_timer(0.7).timeout
	obj.queue_free()
	order_received.emit()
	
func leave(pos: Node3D):
	say_exit_phrase()
	await _move_to(pos)
	queue_free()

func say_exit_phrase():
	await get_tree().create_timer(randf_range(1, 3)).timeout
	label.text = phrases_afer_right.pick_random() if order_correct else phrases_feter_wrong.pick_random()
	await get_tree().create_timer(1.5).timeout
	label.text = ""

func _move_to(pos: Node3D):
	var tween = create_tween()
	tween.tween_property(self, "global_position", pos.global_position, global_position.distance_to(pos.global_position) / speed)
	await tween.finished

func _on_body_entered(body):
	var player = body as PlayerCharacter
	if player and player.current_client == null: 
		player.current_client = self

func _on_body_exited(body):
	var player = body as PlayerCharacter
	if player and player.current_client == self: 
		player.current_client = null
		

var phrases_idle = [
	"Alta gula",
	"Dale loco apuren",
	"Aguante el Tomba",
	"Fua, mirá el tamaño de esa rata"
]

var responses_right = [
	"Grasia ameo",
]

var responses_wrong = [
	"Que mierda es esto?",
	"Esto no es lo que te pedí"
]

var phrases_afer_right = [
	"Los mejores chori de Mendoza",
	"Aguante el Tomba loco",
	"Este chori tiene un gusto raro..."
]

var phrases_feter_wrong = [
	"No vuelvo más acá",
	"Una porqueria",
	"Encima no reciben MercadoPago"
]
