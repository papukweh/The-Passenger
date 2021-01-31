extends Node2D
var current_event = 'begin'

var events_seen = {
	'office_begin': false,
	'go_upstairs': false,
	'window': false,
	'desk': false
}
const events = {
	'office_begin': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	},
	'go_upstairs': {
		'dialogue': [
			""
		],
		'depends_on': 'office_begin',
		'repeat': false
	},
	'office_window': {
		'dialogue': [
			"There is some light coming in through the window",
		],
		'depends_on': 'office_begin',
		'repeat': true
	},
	'office_desk': {
		'dialogue': [
			"You examine the desk and find...",
		],
		'depends_on': 'office_begin',
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

func _on_Upstairs_pressed():
	root._Event_Triggered('go_upstairs')


func _on_Window_pressed():
	root._Event_Triggered('office_window')


func _on_Desk_pressed():
	root._Event_Triggered('office_desk')
