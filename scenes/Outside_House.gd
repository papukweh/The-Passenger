extends Node2D

var events_seen = {
	'begin': false,
	'go_inside': false
}
const events = {
	'begin': {
		'dialogue': [
			"You arrive at the house, but something seems amiss",
			"'This house has seen better days, huh...'",
			"You ring the doorbel repeatedly, yet no one seems to be home"
		],
		'depends_on': null
	},
	'go_inside': {
		'dialogue': [
			"Seems like the door is open",
			"I guess I'll just leave the phone inside", 
			"Couldn't hurt, right?",
			"It can't be trespassing if the door is open, anyway"
		],
		'depends_on': 'begin'
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()

func _on_Door_pressed():
	root._Event_Triggered('go_inside')
