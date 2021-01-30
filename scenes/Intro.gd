extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'rearview': false
}
const events = {
	'begin': {
		'dialogue': [
			"It's 2 A.M",
			"After delivering the final passenger for the day, you are very much looking forward to a good night of sleep",
			"However..."
		],
		'depends_on': null
	},
	'rearview': {
		'dialogue': [
			"You look really tired",
			"'I don't think this is the best time to be appreciating my baggy eyes'"
		],
		'depends_on': 'begin'
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()

func _on_Rearview_pressed():
	print("pressed rearview!")
	root._Event_Triggered('rearview')
