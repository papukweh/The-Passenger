extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'go_hallway': false,
	'cabinet': false,
}
const events = {
	'begin': {
		'dialogue': [
			"The bedroom is filled with religious imagery"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_hallway': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	},
	'cabinet': {
		'dialogue': [
			"You examine the cabinet...",
		],
		'depends_on': null,
		'repeat': true
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()

func _on_Hallway_pressed():
	root._Event_Triggered('go_hallway')


func _on_Cabinet_pressed():
	root._Event_Triggered('cabinet')
