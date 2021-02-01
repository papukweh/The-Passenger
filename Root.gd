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
	"acid_reminder": {
		'dialogue': [
			'You should pour the solution here first'
		],
		'depends_on': null,
		'repeat': true
	},
	'go_safe': {
		'dialogue': [
			"You have both sides of the torn paper now",
			"'Left 17, Right 21, Left 9'",
			"'Time to go to open this safe'"
		],
		'depends_on': null,
		'repeat': false
	},
	'safe': {
		'dialogue': [
			"You finally manage to open the safe"
		],
		'item': 'key',
		'depends_on': 'can_open_safe',
		'repeat': false
	},
	'chase': {
		"dialogue": [
			'Inside you find only a key',
			"'Maybe this can open the entrance?'",
			"'Better get the fuck away from here'",
			"Strangely you hear a door opening",
			"You feel your heart beating faster",
			"Then you hear heavy footsteps coming out of the last corridor room",
			"You feel the urge to run"
		],
		'depends_on': 'safe',
		'repeat': false
	},
	'escape': {
		'dialogue': [
			"You see the entrance",
			"'Fuck, I’m so close'",
			"You finally open the door"
		],
		'depends_on': 'chase',
		'repeat': false
	},
	'death': {
		'dialogue': [
			""
		],
		'depends_on': 'chase',
		'repeat': false
	}
}
var events_seen = {
	'wrong_item': false,
	'acid_reminder': false,
	'screwdriver': false,
	'go_safe': false,
	'can_open_safe': false,
	'bedroom_painting': false,
	'entrance_door': false,
	'safe': false,
	'chase': false,
	'escape': false,
	'death': false,
	'credits_begin': false
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
	'credits': load("res://scenes/Credits.tscn")
}

func _ready():
	OS.set_window_size(Vector2(1080, 720))
	set_process(false)
	dialogue = $GUIPanel3D/Viewport/Dialogue
	inventory = $GUIPanel3D/Viewport/Inventory
	dialogue.connect("event_finished", self, "_on_Event_Finished")
	$SFX.stream = load("res://assets/sfx/door shutting car engine start.wav")
	$SFX.play()
	load_scene("intro")


func load_scene(scene_id: String):
	var scene = scenes[scene_id]
	scene_loaded = false
	$GUIPanel3D.change_scene(scene)
	yield($GUIPanel3D, "scene_loaded")
	yield(get_tree(), "idle_frame")
	var current_scene = $GUIPanel3D.node_base2d.get_child(0)
	print("RESETEI TIMER")
	time_left = 5.0
	if not visited.has(scene_id):
		for k in current_scene.events.keys():
			events[k] = current_scene.events[k]
			events_seen[k] = current_scene.events_seen[k]
	visited.append(scene_id)
	scene_loaded = true
	_Event_Triggered(scene_id+'_begin')
	if scene_id == "intro":
		$SFX.stream = load("res://assets/sfx/car engine running.wav")
		$SFX.play()

var used_in_sink = false
var has_paper1 = false
var has_paper2 = false
func _Event_Triggered(event: String):
	if not scene_loaded or $Animation3D.is_playing() or $GUIPanel3D/Viewport/Animation2D.is_playing() or dialogue.in_dialogue:
		return
	if inventory.selected_item:
		var item = inventory.selected_item
		if item['correct'] == event:
			if item['name'] == 'Bottle':
				used_in_sink = true
				dialogue.init(event, item['use_message'])
			elif item['name'] == 'Screwdriver (rusted)': 
				if used_in_sink:
					dialogue.init('screwdriver', item['use_message'])
					$SFX.stream = load("res://assets/sfx/acid burn.wav")
					$SFX.play()
				else:
					dialogue.init('acid_reminder', [
						'You should pour the solution here first'
					])
					dialogue.start()
					return
			elif item['name'] == 'Screwdriver':
				has_paper2 = true
				dialogue.init('paper2', item['use_message'])
				$SFX.stream = load("res://assets/sfx/painting slide.wav")
				$SFX.play()
			elif item['name'] == 'Key':
				set_process(false)
				dialogue.init('escape', item['use_message'])
				$SFX.stream = load("res://assets/sfx/door opening entrance.wav")
				$SFX.play()
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
		if event == 'bedroom_painting':
			if not events_seen['bedroom_painting']:
				events_seen['bedroom_painting'] = true
				dialogue.init("bedroom_painting", events["bedroom_painting"]['dialogue'])
			elif events_seen["can_open_safe"]:
				dialogue.init("safe", events["safe"]['dialogue'])
			dialogue.start()
			return
		if event.begins_with("go") and not (event == "go" or event == "go_inside") and not can_play:
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
	print("has paper1: "+str(has_paper1))
	print("has paper2: "+str(has_paper2))
	if event == "go_safe":
		has_paper1 = false
		has_paper2 = false
		events_seen['can_open_safe'] = true
	if event == "death":
		$Timer.wait_time = 3.0
		$Timer.start()
		yield($Timer, "timeout")
		$GUIPanel3D/Viewport/Jumpscare.hide()
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
	if event.begins_with("go") and event != "go" and event != "go_safe":
		$SFX.stream = load("res://assets/sfx/footsteps wood player.wav")
		$SFX.play()
	if event == "bedroom_painting" and events_seen['can_open_safe']:
		_Event_Triggered("safe")
	if has_paper1 and has_paper2:
		_Event_Triggered('go_safe')
	elif event == 'escape' or event == 'death':
		load_scene('credits')
		$BGM.stream = load("res://assets/bgm/horror ending song.wav")
		$BGM.play()
	elif event == 'chase':
		start_chase()
	elif event == 'safe':
		$SFX.stream = load("res://assets/sfx/safe opening.wav")
		$SFX.play()
		$Animation3D.play("examine_safe")
		$BGM.stream = load("res://assets/bgm/horror chase song.wav")
		$BGM.play()
	elif event == 'go_house':
		load_scene('outside')
	elif event == 'go':
		load_scene('street')
	elif event == 'go_inside':
		load_scene('entrance')
		if not in_chase:
			$BGM.stream = load("res://assets/bgm/horror ambient song.wav")
			$BGM.play()
	elif event == 'go_upstairs':
		load_scene('upstairs')
		$SFX.stream = load("res://assets/sfx/squeaky floor player.wav")
		$SFX.play()
	elif event == 'go_living_room':
		load_scene('living_room')
	elif event == 'go_kitchen':
		load_scene('kitchen')
	elif event == 'go_office':
		load_scene('office')
	elif event == 'go_hallway':
		load_scene('hallway')
		if not in_chase:
			$BGM.stream = load("res://assets/bgm/horror ambient song.wav")
			$BGM.play()
	elif event == 'go_bedroom':
		load_scene('bedroom')
	elif event == 'go_bathroom':
		load_scene('bathroom')
		if not in_chase:
			$BGM.stream = load("res://assets/bgm/horror bathroom discovery song.wav")
			$BGM.play()

var time_left = 5.0
var sound = ""
var in_chase = false

func _process(delta):
	time_left -= delta
	if time_left <= 0:
		$SFX.stream = load("res://assets/sfx/intense jumpscare.wav")
		$SFX.play()
		$SFX.volume_db = -15
		$GUIPanel3D/Viewport/Jumpscare.show()
		_Event_Triggered("death")
		set_process(false)

func start_chase():
	in_chase = true
	sound = "door_open"
	print("VOU TOCAR ABRIR OPRTA")
	$SFX.stream = load("res://assets/sfx/door open corridor chase.wav")
	$SFX.play()
	set_process(true)


func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "examine_safe":
		$Animation3D.play("acquire_key")
	elif anim_name == "acquire_key":
		$Animation3D.play("spin_key")
		$Timer.start()
		yield($Timer, "timeout")
		_Event_Triggered("chase")
	elif anim_name.begins_with("acquire") and $Animation3D.playback_speed > 2.0:
		var obj = anim_name.substr(8)
		print("PEGUEI OBJETO {obj}".format({'obj': obj}))
		$Animation3D.play("spin_"+obj)
		$Timer.start()
		yield($Timer, "timeout")
		$Animation3D.playback_speed = 2.0
		$Animation3D.play_backwards("acquire_"+obj)



