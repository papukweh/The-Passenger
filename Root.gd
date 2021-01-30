extends Spatial

var dialogue = null
var events = null
var events_seen = null


func _ready():
	dialogue = $GUIPanel3D/Viewport/Dialogue
	dialogue.connect("event_finished", self, "_on_Event_Finished")
	load_scene("res://scenes/Intro.tscn")


func load_scene(scenepath: String):
	var scene = load(scenepath)
	$GUIPanel3D.change_scene(scene)
	yield($GUIPanel3D, "scene_loaded")
	yield(get_tree(), "idle_frame")
	var current_scene = $GUIPanel3D.node_base2d.get_child(0)
	events = current_scene.events
	events_seen = current_scene.events_seen
	_Event_Triggered('begin')


func _Event_Triggered(event: String):
	var depends_on = events[event]['depends_on']
	var can_play = not depends_on or events_seen[depends_on]
	print("triggered {e}, can_play {b}".format({'e':event, 'b':can_play}))
	if not dialogue.in_dialogue and can_play:
		dialogue.init(event, events[event]['dialogue'])
		dialogue.start()


func _on_Event_Finished(event: String):
	print("finished event: {e}".format({'e': event}))
	events_seen[event] = true
	if event == 'rearview':
		load_scene('res://scenes/Outside_House.tscn')


func _on_Rearview_pressed():
	print("pressed rearview!")
	_Event_Triggered('rearview')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "acquire":
		$Animation3D.play("spin")


func _on_Timer_timeout():
	$Animation3D.play("acquire")
