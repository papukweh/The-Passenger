extends Node2D
var current_event = 'begin'

var events_seen = {
	'bathroom_begin': false,
	'bathroom_sink': false,
	'go_hallway': false
}
const events = {
	'bathroom_begin': {
		'dialogue': [
			""
		],
		'depends_on': null,
		'repeat': false
	},
	'bathroom_sink': {
		'dialogue': [
			"The sink is filled with blood"
		],
		'depends_on': 'bathroom_begin',
		'repeat': true
	},
	'go_hallway': {
		'dialogue': [
			""
		],
		'depends_on': 'bathroom_begin',
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


func _on_Sink_pressed():
	root._Event_Triggered('bathroom_sink')


func _on_Hallway_pressed():
	root._Event_Triggered('go_hallway')
