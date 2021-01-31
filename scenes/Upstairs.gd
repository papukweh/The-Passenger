extends Node2D
var current_event = 'begin'

var events_seen = {
	'upstairs_begin': false,
	'go_office': false,
	'go_inside': false,
	'go_hallway': false,
	'upstairs_boarded_wall': false
}
const events = {
	'upstairs_begin': {
		'dialogue': [
			"You climb the stairs, and at the top you look around and see",
			"An office to the front",
			"And a dark hallway to the right"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_inside': {
		'dialogue': [
			""
		],
		'depends_on': 'upstairs_begin',
		'repeat': false
	},
	'go_office': {
		'dialogue': [
			"You decide to enter the office",
		],
		'depends_on': 'upstairs_begin',
		'repeat': false
	},
	'go_hallway': {
		'dialogue': [
			"You decide to enter the hallway",
		],
		'depends_on': 'upstairs_begin',
		'repeat': false
	},
	'upstairs_boarded_wall': {
		'dialogue': [
			"You can see a piece of paper lying behind the boards",
			"'Maybe if I could unscrew these somehow...'"
		],
		'depends_on': 'upstairs_begin',
		'repeat': true
	}
#	'upstairs_wall': {
#		'dialogue': [
#			"You reach for the piece of paper",
#			"It reads: 1, Left 9",
#			"The beginning seems to be torn"
#		],
#		'depends_on': 'upstairs_boarded_wall',
#		'item': 'paper2',
#		'repeat': false
#	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()


onready var objects = $Objects.get_children()
var normal = preload("res://assets/cursor/crosshair031.png")
var special = preload("res://assets/cursor/crosshair032.png")

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		for obj in objects:
			if obj.get_rect().has_point(event.global_position):
				Input.set_custom_mouse_cursor(special)
				$Tooltip.set_text(obj.hint_tooltip)
				var midpoint = obj.get_rect().position + obj.get_rect().size / 2
				$Tooltip.set_global_position(midpoint)
				return
		Input.set_custom_mouse_cursor(normal)
		$Tooltip.set_text("")

func _on_Office_pressed():
	root._Event_Triggered('go_office')


func _on_Back_pressed():
	root._Event_Triggered('go_inside')


func _on_Hallway_pressed():
	root._Event_Triggered('go_hallway')


func _on_Boarded_Wall_pressed():
	root._Event_Triggered('upstairs_boarded_wall')
