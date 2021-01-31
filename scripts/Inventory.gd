extends Node2D
var inventory : Array = []
var selected_item = null
var menu_down = false
var mouse_in = false
var mouse_out = true

onready var slots = $CanvasLayer/Itens.get_children()

const itens = {
	'key': {
		'name': 'Key',
		'thumbnail': 'res://assets/2d/textures/key.png',
		'correct': 'entrance_door',
		'use_message': ['You manage to unlock the door and escape']
	},
	'paper1': {
		'name': 'Piece of paper',
		'thumbnail': 'res://icon.png', #TODO: CHANGE THIS
		'correct': '???',
		'use_message': ['???'],
		'fake': true
	},
	'paper2': {
		'name': 'Folded piece of paper',
		'thumbnail': 'res://icon.png', #TODO: CHANGE THIS
		'correct': '???',
		'use_message': ['???'],
		'fake': true
	},
	'phone': {
		'name': 'Phone',
		'thumbnail': 'res://icon.png',
		'correct': '???',
		'use_message': ['???'],
		'fake': true
	},
	'bottle': {
		'name': 'Bottle',
		'thumbnail': 'res://assets/2d/textures/bottle.png',
		'correct': 'bathroom_sink',
		'use_message': [
			'You block the drain and carefully pours the solution in the messy sink',
			'You can remove the rust from some object now'
		]
	},
	'rusted_screwdriver': {
		'name': 'Screwdriver (rusted)',
		'thumbnail': 'res://assets/2d/textures/screwdriver.png',
		'correct': 'bathroom_sink',
		'use_message': [
			"You carefully dip the screwdriver's tip in the acid",
			"Seems you can use it now!"
		]
	},
	'screwdriver': {
		'name': 'Screwdriver',
		'thumbnail': 'res://assets/2d/textures/screwdriver.png',
		'correct': 'upstairs_boarded_wall',
		'use_message': [
			'You remove the screws, one by one',
			'The board comes out easily',
			"You reach out and grab another piece of paper"
		]
	}
}

func _ready():
	$CanvasLayer/Outline.connect("mouse_entered", self, "mouse_on_button", [true])
	$CanvasLayer/Outline.connect("mouse_exited", self, "mouse_on_button", [false])
	$CanvasLayer/Fill.connect("mouse_entered", self, "mouse_on_button", [true])
	$CanvasLayer/Fill.connect("mouse_exited", self, "mouse_on_button", [false])
	$Lower.connect("mouse_entered", self, "mouse_off_button", [true])
	$Lower.connect("mouse_exited", self, "mouse_off_button", [false])
	$Lower2.connect("mouse_entered", self, "mouse_off_button", [true])
	$Lower2.connect("mouse_exited", self, "mouse_off_button", [false])
	$Lower3.connect("mouse_entered", self, "mouse_off_button", [true])
	$Lower3.connect("mouse_exited", self, "mouse_off_button", [false])
	for i in range(len(slots)):
		var slot = slots[i]
		slot.connect("toggled", self, "_on_Item_Selected", [i])
		slot.connect("mouse_entered", self, "mouse_on_button", [true])
		slot.connect("mouse_exited", self, "mouse_on_button", [false])
		i += 1

func _on_Item_Selected(toggle: bool, index: int):
	print("selected item: {id}, {toggle}".format({'id': index, 'toggle': toggle}))
	if toggle:
		print("Selecionei item: {it}".format({'it': inventory[index]['name']}))
		selected_item = inventory[index]
		for i in range(len(slots)):
			if i != index:
				slots[i].pressed = false
	elif selected_item == inventory[index]:
		selected_item = null


func remove_item():
	for i in range(len(inventory)):
		if inventory[i] == selected_item:
			slots[i].hide()
			break
	selected_item = null


func add_item(item_id: String):
	var item = itens[item_id]
	if not item.get('fake', false):
		var index = len(inventory)
		inventory.append(item)
		$CanvasLayer/Itens.get_node("Slot"+str(index)).show()
		$CanvasLayer/Itens.get_node("Slot"+str(index)).texture_normal = load(item['thumbnail'])
		$CanvasLayer/Itens.get_node("Slot"+str(index)).texture_pressed = load(item['thumbnail'].replace('.png', '_selected.png'))
		$CanvasLayer/Itens.get_node("Slot"+str(index)).hint_tooltip = item['name']
	return item

func _on_Area2D_mouse_entered():
	print("entrou")
	if (not mouse_out or mouse_in) and not $AnimationPlayer.is_playing() and not menu_down:
		print("toquei descer")
		menu_down = true
		$AnimationPlayer.play("show_inventory")


func _on_Area2D_mouse_exited():
	print("saiu")
	if (not mouse_in or mouse_out) and not $AnimationPlayer.is_playing() and menu_down and not selected_item:
		print("toquei subir")
		menu_down = false
		$AnimationPlayer.play_backwards("show_inventory")


func mouse_on_button(place: bool):
	if place:
		mouse_in = true
	else:
		mouse_in = false

func mouse_off_button(place: bool):
	if place:
		mouse_out = true
		_on_Area2D_mouse_exited()
	else:
		mouse_out = false
