extends Node2D
var current_event = 'begin'

var events_seen = {
	'credits_begin': false
}
const events = {
	'credits_begin': {
		'dialogue': [
			"Thank you for playing!",
			"A game by: Dastra and Papu_kweh"
		],
		'depends_on': null,
		'repeat': false
	}
}

