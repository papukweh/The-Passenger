extends Node2D
var current_event = 'begin'

var events_seen = {
	'living_room_begin': false,
	'go_inside': false,
	'living_room_desk': false,
}
const events = {
	'living_room_begin': {
		'dialogue': [
			"It's very dark in here, you can barely see anything"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_inside': {
		'dialogue': [
			""
		],
		'depends_on': 'living_room_begin',
		'repeat': false
	},
	'living_room_desk': {
		'dialogue': [
			"You examine the desk",
			"You find a piece of paper with the following words:",
			"Left 15, Right 2",
			"It seems to be torn at the end",
			"'A combination for a safe? I'll take it just in case"
		],
		'item': 'paper1',
		'depends_on': 'living_room_begin',
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

func _on_Entrance_pressed():
	root._Event_Triggered('go_inside')


func _on_Desk_pressed():
	root._Event_Triggered('living_room_desk')
