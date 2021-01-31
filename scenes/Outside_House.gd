extends Node2D

var events_seen = {
	'outside_begin': false,
	'go_inside': false
}
const events = {
	'outside_begin': {
		'dialogue': [
			"You arrive at the house, but something seems amiss",
			"'This house has seen better days, huh...'",
			"You ring the doorbell repeatedly, yet no one seems to be home"
		],
		'depends_on': null
	},
	'go_inside': {
		'dialogue': [
			"Seems like the door is open",
			"I guess I'll just leave the phone inside", 
			"Couldn't hurt, right?"
		],
		'depends_on': 'outside_begin'
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

func _on_Door_pressed():
	root._Event_Triggered('go_inside')
