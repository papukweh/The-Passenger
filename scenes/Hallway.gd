extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'go_bedroom': false,
	'go_bathroom': false,
	'locked_door': false,
	'go_upstairs': false
}
const events = {
	'begin': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	},
	'go_bedroom': {
		'dialogue': [
			"You decide to enter the bedroom"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_bathroom': {
		'dialogue': [
			"You decide to enter the bathroom"
		],
		'depends_on': null,
		'repeat': false
	},
	'locked_door': {
		'dialogue': [
			"The door is locked",
		],
		'depends_on': null,
		'repeat': false
	},
	'go_upstairs': {
		'dialogue': [
			"",
		],
		'depends_on': null,
		'repeat': false
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()


func _on_Bedroom_pressed():
	root._Event_Triggered('go_bedroom')


func _on_Bathroom_pressed():
	root._Event_Triggered('go_bathroom')


func _on_Door_pressed():
	root._Event_Triggered('locked_door')


func _on_Upstairs_pressed():
	root._Event_Triggered('go_upstairs')
