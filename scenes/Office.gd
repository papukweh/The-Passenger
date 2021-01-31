extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'go_upstairs': false,
	'window': false,
	'desk': false
}
const events = {
	'begin': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	},
	'go_upstairs': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	},
	'window': {
		'dialogue': [
			"There is some light coming in through the window",
		],
		'depends_on': null,
		'repeat': false
	},
	'desk': {
		'dialogue': [
			"You examine the desk and find...",
		],
		'depends_on': null,
		'repeat': false
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()


func _on_Upstairs_pressed():
	root._Event_Triggered('go_upstairs')


func _on_Window_pressed():
	root._Event_Triggered('window')


func _on_Desk_pressed():
	root._Event_Triggered('desk')
