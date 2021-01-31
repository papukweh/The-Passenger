extends Node2D

var events_seen = {
	'street_begin': false,
	'go_house': false
}
const events = {
	'street_begin': {
		'dialogue': [
			"You go back to the street where the final passenger lives",
			"'This was the place I dropped them off'",
			"'Now, to find the correct house'"
		],
		'depends_on': null
	},
	'go_house': {
		'dialogue': [
			"'This is the house, I'm certain of it'"
		],
		'depends_on': 'street_begin'
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




func _on_House_pressed():
	root._Event_Triggered('go_house')
