extends Spatial

const wrong_message = ["I don't think this will help me here..."]

var dialogue = null
var inventory = null
var scene_loaded = false
var first_item = true
var events = {
	'wrong_item': {
		'dialogue': wrong_message,
		'depends_on': null,
		'repeat': true
	},
	'screwdriver': {
		'dialogue': [""],
		'depends_on': null,
		'repeat': false,
		'item': 'screwdriver'
	},
	'paper2': {
		'dialogue': [
			"You reach for the piece of paper",
			"It reads: 1, Left 9",
			"The beginning seems to be torn"
		],
		'depends_on': null,
		'repeat': false,
		'item': 'paper2'
	},
	'go_safe': {
		'dialogue': [
			"You have both sides of the torn paper now",
			"'Left 17, Right 21, Left 9'",
			"'Time to go back to the safe'"
		],
		'depends_on': 'bedroom_painting',
		'repeat': false
	},
	'safe': {
		'dialogue': [
			"You finally manage to open the safe"
		],
		'item': 'key',
		'depends_on': 'go_safe',
		'repeat': false
	}
}
var events_seen = {
	'wrong_item': false,
	'screwdriver': false,
	'go_safe': false,
	'can_open_safe': false,
	'bedroom_painting': false,
	'safe': false
}
var visited = []

var scenes = {
	'intro': load('res://scenes/Intro.tscn'),
	'street': load('res://scenes/Street.tscn'),
	'outside': load('res://scenes/Outside_House.tscn'),
	'entrance': load('res://scenes/Entrance.tscn'),
	'kitchen': load('res://scenes/Kitchen.tscn'),
	'living_room': load('res://scenes/Living_Room.tscn'),
	'upstairs': load('res://scenes/Upstairs.tscn'),
	'office': load('res://scenes/Office.tscn'),
	'hallway': load('res://scenes/Hallway.tscn'),
	'bedroom': load('res://scenes/Bedroom.tscn'),
	'bathroom': load('res://scenes/Bathroom.tscn'),
}

func _ready():
	dialogue = $GUIPanel3D/Viewport/Dialogue
	inventory = $GUIPanel3D/Viewport/Inventory
	dialogue.connect("event_finished", self, "_on_Event_Finished")
	load_scene("kitchen")
	#$Animation3D.play("test")
	#$Objects/safe_with_key/AnimationPlayer.play("open_door")


func load_scene(scene_id: String):
	var scene = scenes[scene_id]
	scene_loaded = false
	$GUIPanel3D.change_scene(scene)
	yield($GUIPanel3D, "scene_loaded")
	yield(get_tree(), "idle_frame")
	var current_scene = $GUIPanel3D.node_base2d.get_child(0)
	if not visited.has(scene_id):
		for k in current_scene.events.keys():
			events[k] = current_scene.events[k]
			events_seen[k] = current_scene.events_seen[k]
	visited.append(scene_id)
	scene_loaded = true
	_Event_Triggered(scene_id+'_begin')

var used_in_sink = false
var has_paper1 = false
var has_paper2 = false
func _Event_Triggered(event: String):
	if not scene_loaded:
		return
	if inventory.selected_item:
		var item = inventory.selected_item
		if item['correct'] == event:
			if item['name'] == 'Bottle':
				used_in_sink = true
				dialogue.init(event, item['use_message'])
			elif item['name'] == 'Screwdriver (rusted)' and used_in_sink:
				dialogue.init('screwdriver', item['use_message'])
			elif item['name'] == 'Screwdriver':
				has_paper2 = true
				dialogue.init('paper2', item['use_message'])
			else:
				dialogue.init(event, item['use_message'])
			inventory.remove_item()
		else:
			dialogue.init("wrong_item", wrong_message)
		dialogue.start()
	else:
		var depends_on = events[event]['depends_on']
		var repeat = events[event].get('repeat') or not events_seen[event]
		var can_play = (not depends_on or events_seen[depends_on]) and repeat
		if event == 'bedroom_painting' and events_seen['can_open_safe']:
			_Event_Triggered("safe")
			return
		elif can_play and event == "safe":
			$Objects/safe_with_key/AnimationPlayer.play("open_door")
		if event.begins_with("go") and not can_play:
			can_play = true
			events[event]['dialogue'] = [""]
		print("triggered {e}, can_play {b}".format({'e':event, 'b':can_play}))
		if events[event]['dialogue']:
			if not dialogue.in_dialogue and can_play:
				dialogue.init(event, events[event]['dialogue'])
				dialogue.start()


func _on_Event_Finished(event: String):
	print("finished event: {e}".format({'e': event}))
	events_seen[event] = true
	if events[event].get('item'):
		var item = events[event]['item']
		if item == 'paper1':
			has_paper1 = true
		$Animation3D.playback_speed = 2.1
		$Animation3D.play("acquire_"+item)
		item = inventory.add_item(item)
		if first_item and not item.get('fake', false):
			dialogue.init('first_item', [
				'<Select the item in your inventory and interact to use it>'
			])
			first_item = false
	if has_paper1 and has_paper2:
		_Event_Triggered('go_safe')
		has_paper1 = false
		has_paper2 = false
		events_seen['can_open_safe'] = true
	elif event == 'safe':
		start_chase()
	elif event == 'go_house':
		load_scene('outside')
	elif event == 'go':
		load_scene('street')
	elif event == 'go_inside':
		load_scene('entrance')
	elif event == 'go_upstairs':
		load_scene('upstairs')
	elif event == 'go_living_room':
		load_scene('living_room')
	elif event == 'go_kitchen':
		load_scene('kitchen')
	elif event == 'go_office':
		load_scene('office')
	elif event == 'go_hallway':
		load_scene('hallway')
	elif event == 'go_bedroom':
		load_scene('bedroom')
	elif event == 'go_bathroom':
		load_scene('bathroom')

func open_safe():
	$Objects/safe_with_key/AnimationPlayer.play("open_door")

func start_chase():
	print("START CHASE AAA")

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name.begins_with("acquire") and $Animation3D.playback_speed > 2.0:
		var obj = anim_name.substr(8)
		print("PEGUEI OBJETO {obj}".format({'obj': obj}))
		$Animation3D.play("spin_"+obj)
		$Timer.start()
		yield($Timer, "timeout")
		$Animation3D.playback_speed = 2.0
		$Animation3D.play_backwards("acquire_"+obj)
