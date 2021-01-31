extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'go_office': false,
	'go_back': false,
	'go_hallway': false,
	'boarded_wall': false
}
const events = {
	'begin': {
		'dialogue': [
			"Upstairs, you look around and see",
			"An office to the front",
			"A dark hallway to the right"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_back': {
		'dialogue': [
			"You decide to return to the entrance"
		],
		'depends_on': 'begin',
		'repeat': false
	},
	'go_office': {
		'dialogue': [
			"You decide to enter the office",
		],
		'depends_on': 'begin',
		'repeat': false
	},
	'go_hallway': {
		'dialogue': [
			"You decide to enter the hallway",
		],
		'depends_on': 'begin',
		'repeat': false
	},
	'boarded_wall': {
		'dialogue': [
			"You can see a piece of paper lying behind the boards",
			"'Maybe if I could unscrew those somehow...'"
		],
		'depends_on': 'begin',
		'repeat': true
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()


func _on_Office_pressed():
	root._Event_Triggered('go_office')


func _on_Back_pressed():
	root._Event_Triggered('go_inside')


func _on_Hallway_pressed():
	root._Event_Triggered('go_hallway')
