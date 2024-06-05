extends Node2D

const CONVERSATION_ID = "shower"
const LINES: Array[String] = [
	"Could really use a shower.",
	"What happened last night?",
	"I can't remember a thing..."
]

const INTERACTED_LINES: Array[String] = [
	"No water."
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
