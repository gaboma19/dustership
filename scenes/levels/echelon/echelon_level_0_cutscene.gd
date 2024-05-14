extends Node

const CONVERSATION_ID = "intro_cutscene"
const LINES: Array[String] = [
	"Ugh... my head..."
]
const LINES2: Array[String] = [
	"...What is that strange light?"
]

func _ready():
	if not EntityVariables.conversations.has(CONVERSATION_ID):
		await get_tree().get_first_node_in_group("entities").ready
		var player = PartyManager.get_active_member() as Player
		player.state_machine.transition_to("Hold")
		$AnimationPlayer.play("default")
		EntityVariables.conversations[CONVERSATION_ID] = { "interacted": true }


func april_intro_conversation():
	var player = PartyManager.get_active_member() as Player
	if player.character_name == Constants.CharacterNames.APRIL:
		player.speak(LINES)
		await DialogueManager.finished_dialogue
		player.update_blend_position(Vector2.UP)
		await get_tree().create_timer(0.4).timeout
		player.speak(LINES2)
		player.state_machine.transition_to("Active")
