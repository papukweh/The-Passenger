extends Spatial

func _ready():
	pass




func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "acquire":
		$AnimationPlayer.play("spin")


func _on_Timer_timeout():
	$AnimationPlayer.play("acquire")
