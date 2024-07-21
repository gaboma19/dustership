extends Node2D

const TELITZ_SCENE = preload("res://scenes/entities/players/telitz/telitz.tscn")
const DUSTERSHIP_LEVEL_1_SCENE_PATH = "res://scenes/levels/dustership/dustership_level_1.tscn"
const EREMITE_DISKETTE = preload(
	"res://resources/inventory_item/items/eremite_diskette.tres")
const CONVERSATION_ID = "computer"
const EREMITE_DISKETTE_CONVERSATION_ID = "eremite_diskette"
const LINES: Array[String] = [
	"Welp, looks like there's no power.",
	"Is this ship still running?"
]
const INTERACTED_LINES: Array[String] = [
	"It won't turn on."
]
const HAS_EREMITE_DISKETTE_LINES: Array[String] = [
	"It won't turn on.",
	"Hmm... should I try using the diskette I found?"
]
const YES_LINES: Array[String] = [
	"Here goes."
]
const NO_LINES: Array[String] = [
	"Nevermind..."
]
const CUBE_YES_LINES: Array[String] = [
	"ALERT. Anomalous energy signature detected."
]
const APRIL_YES_LINES: Array[String] = [
	"That sounds bad."
]

var april: Player

@onready var turned_on_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var post_process = $"../PostProcess"


func _ready():
	PopUp.closed.connect(on_decision_container_closed)
	$InteractionArea.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(CONVERSATION_ID):
		EntityVariables.conversations[CONVERSATION_ID] = { "interacted": false }


func on_interact():
	april = PartyManager.get_april() as Player
	april.update_blend_position(Vector2.UP)
	
	if Inventory.use_item_by_name("eremite_diskette"):
		$InteractionArea.set_deferred("monitoring", false)
		april.speak(HAS_EREMITE_DISKETTE_LINES)
		await DialogueManager.finished_dialogue
		
		PopUp.open_decision_container("Will you use the diskette?")
		
		return
	
	if not EntityVariables.conversations[CONVERSATION_ID].interacted:
		april.speak(LINES)
		EntityVariables.conversations[CONVERSATION_ID].interacted = true
	else:
		april.speak(INTERACTED_LINES)


func on_decision_container_closed(msg: String):	
	if msg == "Yes":
		april.state_machine.transition_to("Hold")
		var cube = PartyManager.get_cube()
		
		april.speak(YES_LINES)
		await DialogueManager.finished_dialogue
		
		turned_on_sprite.show()
		await get_tree().create_timer(2).timeout
		april.update_blend_position(Vector2.DOWN)
		cube.speak(CUBE_YES_LINES)
		await DialogueManager.finished_dialogue
		
		april.speak(APRIL_YES_LINES)
		await DialogueManager.finished_dialogue
		
		post_process.configuration.ScreenShake = true
		
		cube.update_blend_position(Vector2.DOWN)
		
		await get_tree().create_timer(1).timeout
		animation_player.play("default")
		await get_tree().create_timer(0.2).timeout
		post_process.configuration.Glitch = true
		
		animation_player.play("fade_to_white")
		MusicManager.fade_out()
		
		await get_tree().create_timer(8.0).timeout
		
		var telitz = TELITZ_SCENE.instantiate()
		var entities_layer = get_tree().get_first_node_in_group("entities")
		entities_layer.add_child(telitz)
		telitz.global_position = cube.global_position
		
		PartyManager.remove_member(april)
		PartyManager.remove_member(cube)
		april.queue_free()
		cube.queue_free()
		
		post_process.configuration.Glitch = false
		post_process.configuration.ScreenShake = false
		
		ScreenTransition.transition_to_level(DUSTERSHIP_LEVEL_1_SCENE_PATH, Vector2(0, 0))
		
	elif msg == "No":
		$InteractionArea.set_deferred("monitoring", true)
		Inventory.add_item(EREMITE_DISKETTE)
		
		april.speak(NO_LINES)
		await DialogueManager.finished_dialogue
	
		april.state_machine.transition_to("Active")
