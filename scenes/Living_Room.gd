extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'go_inside': false,
	'living_room_desk': false,
}
const events = {
	'begin': {
		'dialogue': [
			"It's very dark, you can barely see anything"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_inside': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	},
	'living_room_desk': {
		'dialogue': [
			"You examine a desk",
		],
		'depends_on': null,
		'repeat': true
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()


func _on_Entrance_pressed():
	root._Event_Triggered('go_inside')


func _on_Desk_pressed():
	root._Event_Triggered('living_room_desk')
