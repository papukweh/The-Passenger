extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'go_kitchen': false,
	'go_upstairs': false,
	'go_living_room': false
}
const events = {
	'begin': {
		'dialogue': [
			"You are greeted by a dark room with some stairs",
			"'Damn, it's really dark in here'",
			"You start using your cellphone as a flashlight"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_kitchen': {
		'dialogue': [
			"You decide to enter the kitchen"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_upstairs': {
		'dialogue': [
			"You decide to climb the stairway",
		],
		'depends_on': null,
		'repeat': false
	},
	'go_living_room': {
		'dialogue': [
			"You decide to enter the living room",
		],
		'depends_on': null,
		'repeat': false
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()


func _on_Upstairs_pressed():
	root._Event_Triggered('go_upstairs')


func _on_Living_Room_pressed():
	root._Event_Triggered('go_living_room')


func _on_Kitchen_pressed():
	root._Event_Triggered('go_kitchen')
