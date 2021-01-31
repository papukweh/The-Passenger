extends Node2D
var current_event = 'begin'

var events_seen = {
	'hallway_begin': false,
	'go_bedroom': false,
	'go_bathroom': false,
	'locked_door': false,
	'go_upstairs': false
}
const events = {
	'hallway_begin': {
		'dialogue': [
			"The hallway is very much uninviting"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_bedroom': {
		'dialogue': [
			"You decide to enter the bedroom"
		],
		'depends_on': 'hallway_begin',
		'repeat': false
	},
	'go_bathroom': {
		'dialogue': [
			"You decide to enter the bathroom"
		],
		'depends_on': 'hallway_begin',
		'repeat': false
	},
	'locked_door': {
		'dialogue': [
			"The door is locked",
		],
		'depends_on': 'hallway_begin',
		'repeat': true
	},
	'go_upstairs': {
		'dialogue': [
			"",
		],
		'depends_on': 'hallway_begin',
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

func _on_Bedroom_pressed():
	root._Event_Triggered('go_bedroom')


func _on_Bathroom_pressed():
	root._Event_Triggered('go_bathroom')


func _on_Door_pressed():
	root._Event_Triggered('locked_door')


func _on_Upstairs_pressed():
	root._Event_Triggered('go_upstairs')
