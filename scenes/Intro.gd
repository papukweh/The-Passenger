extends Node2D

const dialogues = [
	"It's 2 A.M",
	"After delivering the final passenger for the day, you are very much looking forward to a good night of sleep",
	"However..."
]


# Called when the node enters the scene tree for the first time.
func _ready():
	$Dialogue.init(dialogues)
	$Dialogue.start()
