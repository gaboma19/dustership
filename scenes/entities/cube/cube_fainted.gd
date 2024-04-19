extends StaticBody2D

const LINES: Array[String] = [
	"This is a combat droid.",
	"I recognize the model.",
	"What is it doing in this place?",
	"Looks pretty badly hurt.",
	"I know how to fix it but...",
	"it's missing a few pieces.",
	"I should have a look around."
]

const INTERACTED_LINES: Array[String] = [
	"It's a broken combat Cube.",
	"I need to find this guy's missing parts."
]

const CONVERSATION_ID: String = "cube_fainted"

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(CONVERSATION_ID):
		EntityVariables.conversations[CONVERSATION_ID] = { "interacted": false }


func on_interact():
	var player = PartyManager.get_active_member() as Player
	if not EntityVariables.conversations[CONVERSATION_ID].interacted:
		player.speak(LINES)
		EntityVariables.conversations[CONVERSATION_ID].interacted = true
	else:
		player.speak(INTERACTED_LINES)
