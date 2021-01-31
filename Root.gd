extends Spatial

var dialogue = null
var inventory = null
var events = null
var events_seen = null


func _ready():
	dialogue = $GUIPanel3D/Viewport/Dialogue
	inventory = $GUIPanel3D/Viewport/Inventory
	dialogue.connect("event_finished", self, "_on_Event_Finished")
	load_scene("res://scenes/Intro.tscn")
	#$Animation3D.play("test")
	$Objects/safe_with_key/AnimationPlayer.play("open_door")


func load_scene(scenepath: String):
	var scene = load(scenepath)
	$GUIPanel3D.change_scene(scene)
	yield($GUIPanel3D, "scene_loaded")
	yield(get_tree(), "idle_frame")
	var current_scene = $GUIPanel3D.node_base2d.get_child(0)
	events = current_scene.events
	events['wrong_item'] = {
		'dialogue': inventory.wrong_message,
		'depends_on': null,
		'repeat': true
	}
	events_seen = current_scene.events_seen
	events_seen['wrong_item'] = false
	_Event_Triggered('begin')


func _Event_Triggered(event: String):
	if inventory.selected_item:
		var item = inventory.selected_item
		if item['correct'] == event:
			dialogue.init(event, item['use_message'])
		else:
			dialogue.init("wrong_item", inventory.wrong_message)
		dialogue.start()
	else:
		var depends_on = events[event]['depends_on']
		var repeat = events[event].get('repeat') or not events_seen[event]
		var can_play = (not depends_on or events_seen[depends_on]) and repeat
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
		inventory.add_item(item)
	elif event == 'go':
		load_scene('res://scenes/Outside_House.tscn')
	elif event == 'go_inside':
		load_scene('res://scenes/Entrance.tscn')
	elif event == 'go_upstairs':
		load_scene('res://scenes/Upstairs.tscn')
	elif event == 'go_living_room':
		load_scene('res://scenes/Living_Room.tscn')
	elif event == 'go_kitchen':
		load_scene('res://scenes/Kitchen.tscn')
	elif event == 'go_office':
		load_scene('res://scenes/Office.tscn')
	elif event == 'go_hallway':
		load_scene('res://scenes/Hallway.tscn')
	elif event == 'go_bedroom':
		load_scene('res://scenes/Bedroom.tscn')
	elif event == 'go_bathroom':
		load_scene('res://scenes/Bathroom.tscn')


func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name.begins_with("acquire") and $Animation3D.playback_speed > 2.0:
		var obj = anim_name.substr(8)
		print("PEGUEI OBJETO {obj}".format({'obj': obj}))
		$Animation3D.play("spin_"+obj)
		$Timer.start()
		yield($Timer, "timeout")
		$Animation3D.playback_speed = 2.0
		$Animation3D.play_backwards("acquire_key")
