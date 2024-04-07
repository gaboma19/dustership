extends StaticBody2D

@onready var interaction_area = $InteractionArea

const lines: Array[String] = [
	"This is a combat droid.",
	"I recognize the model.",
	"What is it doing in this place?",
	"Looks pretty badly hurt.",
	"I know how to fix it but...",
	"it's missing a few pieces.",
	"I should have a look around."
]

const interacted_lines: Array[String] = [
	"It's a broken combat Cube.",
	"I need to find this guy's missing parts."
]

var interacted = false


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	
func on_interact():
	var player = get_tree().get_first_node_in_group("player") as Player
	if not interacted:
		player.speak(lines)
		interacted = true
	else:
		player.speak(interacted_lines)
