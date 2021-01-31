extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'go_inside': false,
	'kitchen_cabinets': false
}
const events = {
	'begin': {
		'dialogue': [
			""
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
	'kitchen_cabinets': {
		'dialogue': [
			"Nothing interesting in here"
		],
		'depends_on': null,
		'repeat': true
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()


func _on_Entrance_pressed():
	root._Event_Triggered('go_inside')


func _on_Cabinets_pressed():
	root._Event_Triggered('kitchen_cabinets')
