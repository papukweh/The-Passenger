extends Node2D
var current_event = 'begin'

var events_seen = {
	'entrance_begin': false,
	'go_kitchen': false,
	'go_upstairs': false,
	'go_living_room': false,
	'entrance_door': false
}
const events = {
	'entrance_begin': {
		'dialogue': [
			"You are greeted by a dark room with some stairs",
			"'Damn, it's really dark in here'",
			"Suddenly, with a gush of wind, the door closes behind you",
			"'Agh!'",
			"You try to open it, with no success",
			"'Damn, it locked itself automatically'",
			"I'd better call for the passenger",
			"'HELLO!! ARE YOU HOME??'",
			"But no one answers",
			"'What a fucking stint I got myself into'",
			"'So much for being nice'",
			"'I'll just find the key, and then be outta here in no time'"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_kitchen': {
		'dialogue': [
			"You decide to enter the kitchen"
		],
		'depends_on': 'entrance_begin',
		'repeat': false
	},
	'go_upstairs': {
		'dialogue': [
			"You decide to climb the stairway",
		],
		'depends_on': 'entrance_begin',
		'repeat': false
	},
	'go_living_room': {
		'dialogue': [
			"You decide to enter the living room",
		],
		'depends_on': 'entrance_begin',
		'repeat': false
	},
	'entrance_door': {
		'dialogue': [
			"I need to use the key!"
		],
		'depends_on': null,
		'repeat': true
	}
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

func _on_Upstairs_pressed():
	root._Event_Triggered('go_upstairs')


func _on_Living_Room_pressed():
	root._Event_Triggered('go_living_room')


func _on_Kitchen_pressed():
	root._Event_Triggered('go_kitchen')


func _on_Entrance_Door_pressed():
	root._Event_Triggered('entrance_door')
