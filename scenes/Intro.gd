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



# Called when the node enters the scene tree for the first time.
func _ready():
	$Dialogue.connect("event_finished", self, "_on_Event_Finished")
	$AnimationPlayer.play("fade_in")


func _Event_Triggered(event: String):
	var depends_on = events[event]['depends_on']
	var can_play = not depends_on or events_seen[depends_on]
	print("triggered {e}, can_play {b}".format({'e':event, 'b':can_play}))
	if not $Dialogue.in_dialogue and can_play:
		$Dialogue.init(event, events[event]['dialogue'])
		$Dialogue.start()


func _on_Event_Finished(event: String):
	print("finished event: {e}".format({'e': event}))
	events_seen[event] = true


func _on_Rearview_pressed():
	print("pressed rearview!")
	_Event_Triggered('rearview')



func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "fade_in":
		_Event_Triggered('begin')
