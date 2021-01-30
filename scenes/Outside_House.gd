extends Node2D

const dialogues = {
	'begin': [
		"You arrive at the house, but something seems amiss",
		"'This house has seen better days, huh...'",
		"You ring the doorbel repeatedly, yet no one seems to be home"
	],
	'door': [
		"Seems like the door is open",
		"I guess I'll just leave the phone inside", 
		"Couldn't hurt, right?",
		"It can't be trespassing if the door is open, anyway"
	]
}

func _ready():
	event_triggered('begin')


func event_triggered(event: String):
	$Dialogue.init(dialogues[event])
	$Dialogue.start()


func _on_Door_pressed():
	if not $Dialogue.in_dialogue:
		event_triggered('door')
