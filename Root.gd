extends Spatial

func _ready():
	load_scene("res://scenes/Intro.tscn")


func load_scene(scenepath: String):
	var scene = load(scenepath)
	$GUIPanel3D.node_viewport.get_child(0).queue_free()
	$GUIPanel3D.node_viewport.add_child(scene.instance())
	$GUIPanel3D.reload_texture()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "acquire":
		$AnimationPlayer.play("spin")


func _on_Timer_timeout():
	$AnimationPlayer.play("acquire")
