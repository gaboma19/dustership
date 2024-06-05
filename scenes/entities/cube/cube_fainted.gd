extends StaticBody2D

const LINES: Array[String] = [
	"This is a combat droid. I recognize the model.",
	"Looks pretty busted.",
	"It's missing a few pieces.",
	"I should have a look around."
]

const INTERACTED_LINES: Array[String] = [
	"It's a broken combat Cube.",
	"Maybe I can find its missing parts."
]

const HAS_IDENTITY_CORE_LINES: Array[String] = [
	"Found your missing component, droid.",
	"Gonna wake you up now. Sure hope you don't try to kill me."
]

const CUBE_LINES: Array[String] = [
	"Hello, world!",
	"The time is 12:00:00 Ammellan Mean Time.",
	"DIRECTIVE! Investigate and destroy illegal Echelonic technology.",
	"DIRECTIVE STATUS! Critical failure.",
	"Ammellan military officer detected. Assuming squad formation."
]

const APRIL_RESPONSE_LINES: Array[String] = [
	"Great."
]

const CONVERSATION_ID: String = "cube_fainted"
const CUBE_FIXED_CONVERSATION_ID: String = "cube_fixed"

@export var telitz_denz: Npc

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(CONVERSATION_ID):
		EntityVariables.conversations[CONVERSATION_ID] = { "interacted": false }
	
	if EntityVariables.conversations.has(CUBE_FIXED_CONVERSATION_ID):
		if EntityVariables.conversations[CUBE_FIXED_CONVERSATION_ID].interacted:
			queue_free()
	else:
		EntityVariables.conversations[CUBE_FIXED_CONVERSATION_ID] = { "interacted": false }


func on_interact():
	var player = PartyManager.get_active_member() as Player
	
	if Inventory.use_item_by_name("identity_core"):
		EntityVariables.conversations[CUBE_FIXED_CONVERSATION_ID].interacted = true
		
		player.speak(HAS_IDENTITY_CORE_LINES)
		await DialogueManager.finished_dialogue
		
		const CUBE_SCENE = preload("res://scenes/entities/players/cube.tscn")
		var cube = CUBE_SCENE.instantiate()
		var entities_layer = get_tree().get_first_node_in_group("entities")
		entities_layer.add_child(cube)
		cube.global_position = global_position
		hide()
		
		cube.speak(CUBE_LINES)
		await DialogueManager.finished_dialogue
		player.speak(APRIL_RESPONSE_LINES)
		await DialogueManager.finished_dialogue
		
		player.state_machine.transition_to("Hold")
		telitz_denz.state_machine.transition_to("Spawn")
		
		
		PopUp.open_party_instructions()
		queue_free()
		return
	
	
	if not EntityVariables.conversations[CONVERSATION_ID].interacted:
		player.speak(LINES)
		EntityVariables.conversations[CONVERSATION_ID].interacted = true
	else:
		player.speak(INTERACTED_LINES)
