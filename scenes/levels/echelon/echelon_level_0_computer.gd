extends Node2D

const CONVERSATION_ID = "computer"
const LINES: Array[String] = [
	"Welp, looks like there's no power.",
	"What is going on?"
]

const INTERACTED_LINES: Array[String] = [
	"It won't turn on."
]


func _ready():
	$InteractionArea.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(CONVERSATION_ID):
		EntityVariables.conversations[CONVERSATION_ID] = { "interacted": false }


func on_interact():
	var april = PartyManager.get_april() as Player
	april.update_blend_position(Vector2.UP)
	if not EntityVariables.conversations[CONVERSATION_ID].interacted:
		april.speak(LINES)
		EntityVariables.conversations[CONVERSATION_ID].interacted = true
	else:
		april.speak(INTERACTED_LINES)
