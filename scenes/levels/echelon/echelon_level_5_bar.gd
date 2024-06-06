extends Node2D

const CONVERSATION_ID = "bar"
const LINES: Array[String] = [
	"It's an old bar. Place looks like San Pengpo.",
	"I don't think this is one of my memories...?",
]

const LINES2: Array[String] = [
	"Unless the Echelon is simulating something I forgot.",
	"Oh... maybe this is a memory of that Cube droid I saw."
]

const INTERACTED_LINES: Array[String] = [
	"It's an old bar, covered in vines. This place looks like one of the cantinas on San Pengpo."
]

@onready var events = get_tree().get_first_node_in_group("events")


func _ready():
	$InteractionArea.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(CONVERSATION_ID):
		EntityVariables.conversations[CONVERSATION_ID] = { "interacted": false }


func on_interact():
	var april = PartyManager.get_april()
	
	if not EntityVariables.conversations[CONVERSATION_ID].interacted:
		EntityVariables.conversations[CONVERSATION_ID].interacted = true
		
		april.state_machine.transition_to("Hold")
		april.update_blend_position(Vector2.UP)
		
		april.speak(LINES)
		await DialogueManager.finished_dialogue
		
		april.update_blend_position(Vector2.LEFT)
		await get_tree().create_timer(1.0).timeout
		april.speak(LINES2)
		await DialogueManager.finished_dialogue
		
		april.update_blend_position(Vector2.DOWN)
		await get_tree().create_timer(0.1).timeout
		april.update_blend_position(Vector2.RIGHT)
		events.spawn_enemies()
		
		april.state_machine.transition_to("Active")
	else:
		april.speak(INTERACTED_LINES)
