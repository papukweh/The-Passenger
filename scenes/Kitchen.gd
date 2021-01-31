extends Node2D
var current_event = 'begin'

var events_seen = {
	'kitchen_begin': false,
	'go_inside': false,
	'kitchen_cabinets': false
}
const events = {
	'kitchen_begin': {
		'dialogue': [
			"The walls are a bit old, but you don't find anything unusual in here"
		],
		'depends_on': null,
		'repeat': false
	},
	'go_inside': {
		'dialogue': [
			""
		],
		'depends_on': 'kitchen_begin',
		'repeat': false
	},
	'kitchen_cabinets': {
		'dialogue': [
			"You examine the cabinets",
			"Inside, there is an old screwdriver",
			"'Hey, this might come in handy'",
			"'Too bad the tip is all rusted'",
			"You might need to remove the rust somehow if you want to use it..."
		],
		'depends_on': 'kitchen_begin',
		'item': 'rusted_screwdriver',
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

func _on_Entrance_pressed():
	root._Event_Triggered('go_inside')


func _on_Cabinets_pressed():
	root._Event_Triggered('kitchen_cabinets')
