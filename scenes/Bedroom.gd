extends Node2D
var current_event = 'begin'

var events_seen = {
	'bedroom_begin': false,
	'go_hallway': false,
	'bedroom_cabinet': false,
	'bedroom_painting': false
}
const events = {
	'bedroom_begin': {
		'dialogue': [
			"The bedroom is filled with religious imagery",
			"You feel a chill across your spine"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_hallway': {
		'dialogue': [
			""
		],
		'depends_on': 'bedroom_begin',
		'repeat': false
	},
	'bedroom_cabinet': {
		'dialogue': [
			"You examine the cabinet",
			"But find nothing of note"
		],
		'depends_on': 'bedroom_begin',
		'repeat': true
	},
	'bedroom_painting': {
		'dialogue': [
			"You examine the picture",
			"It comes off in your hands!",
			"Behind it, there's gray safe",
			"'How cliche...'",
			"You looked everywhere but couldn't find the key",
			"'Maybe in here...?'"
		],
		'depends_on': 'bedroom_begin',
		'repeat': true
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

func _on_Hallway_pressed():
	root._Event_Triggered('go_hallway')


func _on_Cabinet_pressed():
	root._Event_Triggered('bedroom_cabinet')


func _on_Painting_pressed():
	root._Event_Triggered('bedroom_painting')
