extends Node2D
var current_event = 'begin'

var events_seen = {
	'intro_begin': false,
	'intro_rearview': false,
	'go': false
}
const events = {
	'intro_begin': {
		'dialogue': [
			"It's 2 A.M",
			"After delivering the final passenger for the day, you are very much looking forward to a good night of sleep",
			"However..."
		],
		'depends_on': null,
		'repeat': false
	},
	'intro_rearview': {
		'dialogue': [
			"You look really tired",
			"'I don't think this is the best time to be appreciating my baggy eyes'",
			"Oh, look. A key!"
		],
		'item': 'key',
		'depends_on': 'intro_begin',
		'repeat': false
	},
	'go': {
		'dialogue': [
			"'Well, they didn't live far, at least'",
			"'Guess I'll pay them a quick visit"
		],
		'depends_on': 'intro_rearview',
		'repeat': false
	}
}

onready var root = get_parent().get_parent().get_parent().get_parent()

onready var objects = $Objects.get_children()
var normal = preload("res://assets/cursor/crosshair031.png")
var special = preload("res://assets/cursor/crosshair032.png")

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		for obj in objects:
			if obj.get_rect().has_point(event.global_position):
				Input.set_custom_mouse_cursor(special)
				$Tooltip.set_text(obj.hint_tooltip)
				var midpoint = obj.get_rect().position + obj.get_rect().size / 2
				$Tooltip.set_global_position(midpoint)
				return
		Input.set_custom_mouse_cursor(normal)
		$Tooltip.set_text("")

func _on_Rearview_pressed():
	print("pressed rearview!")
	root._Event_Triggered('intro_rearview')


func _on_Go_pressed():
	root._Event_Triggered('go')
