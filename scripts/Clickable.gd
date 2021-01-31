extends Control

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if get_rect().has_point(event.global_position):
			emit_signal("pressed")
