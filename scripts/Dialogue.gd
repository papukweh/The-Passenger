extends Node2D
var lines : Array = [
	"Well, hello, kind sir", 
	"This is a test dialogue", 
	"You realize the passenger might have left something behind on the backseat..."
]
var in_dialogue = false
var current_dialogue = ""

func _ready():
	pass
	#init(lines)
	#start()


func init(lines_arg: Array):
	lines = lines_arg.duplicate()


func start():
	in_dialogue = true
	next()


func next():
	var next = lines.pop_front()
	if next:
		set_dialogue(next)
	else:
		in_dialogue = false
		$CanvasLayer/Text.set_text("")


func set_dialogue(text: String):
	current_dialogue = text
	$CanvasLayer/Tween.follow_method(
		self, "set_text", 0, 
		self, "get_length", 0.05*len(text), 
		Tween.TRANS_LINEAR, 0, 0
	)
	$CanvasLayer/Tween.set_speed_scale(2.5)
	$CanvasLayer/Tween.start()


func set_text(value: float):
	$CanvasLayer/Text.set_text(current_dialogue.substr(0,floor(value)))
	$CanvasLayer/Audio.pitch_scale = rand_range(0.95, 1.05)
	$CanvasLayer/Audio.play()


func get_length():
	return len(current_dialogue)


func _input(event: InputEvent):
	if event.is_action_pressed("left_click") and in_dialogue:
		if $CanvasLayer/Tween.is_active():
			$CanvasLayer/Tween.set_speed_scale(5.0)
		else:
			next()
