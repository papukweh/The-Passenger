extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'sink': false,
	'go_hallway': false
}
const events = {
	'begin': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	},
	'sink': {
		'dialogue': [
			"The sink is filled with blood"
		],
		'depends_on': null,
		'repeat': true
	},
	'go_hallway': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()



func _on_Sink_pressed():
	root._Event_Triggered('sink')


func _on_Hallway_pressed():
	root._Event_Triggered('go_hallway')
