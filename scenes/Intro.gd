extends Node2D
var current_event = 'begin'

var events_seen = {
	'begin': false,
	'rearview': false,
	'go': false
}
const events = {
	'begin': {
		'dialogue': [
			"It's 2 A.M",
			"After delivering the final passenger for the day, you are very much looking forward to a good night of sleep",
			"However..."
		],
		'depends_on': null,
		'repeat': false
	},
	'rearview': {
		'dialogue': [
			"You look really tired",
			"'I don't think this is the best time to be appreciating my baggy eyes'",
			"Oh, look. A key!"
		],
		'item': 'key',
		'depends_on': 'begin',
		'repeat': false
	},
	'go': {
		'dialogue': [
			"'Well, they didn't live far, at least'",
			"'Guess I'll pay them a quick visit"
		],
		'depends_on': 'rearview',
		'repeat': false
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()

func _on_Rearview_pressed():
	print("pressed rearview!")
	root._Event_Triggered('rearview')


func _on_Go_pressed():
	root._Event_Triggered('go')
