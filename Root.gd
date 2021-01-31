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
	}
}
var events_seen = {
	'wrong_item': false
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


func _Event_Triggered(event: String):
	if not scene_loaded:
		return
	if inventory.selected_item:
		var item = inventory.selected_item
		if item['correct'] == event:
			dialogue.init(event, item['use_message'])
		else:
			dialogue.init("wrong_item", wrong_message)
		dialogue.start()
	else:
		var depends_on = events[event]['depends_on']
		var repeat = events[event].get('repeat') or not events_seen[event]
		var can_play = (not depends_on or events_seen[depends_on]) and repeat
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
		$Animation3D.playback_speed = 2.1
		$Animation3D.play("acquire_"+item)
		item = inventory.add_item(item)
		if first_item and not item.get('fake', false):
			dialogue.init('first_item', [
				'<Select the item in your inventory and interact to use it>'
			])
			first_item = false
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


func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name.begins_with("acquire") and $Animation3D.playback_speed > 2.0:
		var obj = anim_name.substr(8)
		print("PEGUEI OBJETO {obj}".format({'obj': obj}))
		$Animation3D.play("spin_"+obj)
		$Timer.start()
		yield($Timer, "timeout")
		$Animation3D.playback_speed = 2.0
		$Animation3D.play_backwards("acquire_"+obj)
