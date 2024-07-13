extends State

const TELITZ_LINES_1: Array[String] = [
	"Ah hah, I see the friendly combat Cube is feeling better.",
	"I hope you've thanked our new friend April for fixing you."
]

const CUBE_LINES_2: Array[String] = [
	"Telitz Denz.", 
	"You are wanted by the Ammellan administration for the use of illegal Echelonic technology."
]

const TELITZ_LINES_3: Array[String] = [
	"Don't you remember me, Cube?",
	"It's thanks to your help that my followers and I have been able to restore this place.",
]

const CUBE_LINES_4: Array[String] = [
	"You are under arrest.",
]

const CUBE_LINES_5: Array[String] = [
	"Ammellan officer. Detain this criminal."
]

const APRIL_LINES_6: Array[String] = [
	"It's April. And I'm not an Ammellan officer anymore. I'm... an independent contractor."
]

const APRIL_LINES_7: Array[String] = [
	"Uh, so you know this Cube?"
]

const TELITZ_LINES_8: Array[String] = [
	"Yes. He is... was an arms dealer operating in the Fringes.",
	"His help was instrumental to our cause... the Eremite renaissance.",
	"Someone wiped his identity core and turned it against me."
]

const APRIL_LINES_9: Array[String] = [
	"Who?"
]

const TELITZ_LINES_10: Array[String] = [
	"The Ammellans, of course.",
	"Someone high ranking in the administration. And someone who knew Cube had access to the Echelon.",
	"Maybe someone you know, April?"
]

const APRIL_LINES_11: Array[String] = [
	"Heh. Maybe. It's been a long time.",
	"I didn't exactly leave on the best terms after the Coronation."
]

const TELITZ_LINES_12: Array[String] = [
	"Well, keep an eye on Cube for me. It would be good if he remembered his old self again."
]

const CUBE_LINES_13: Array[String] = [
	"Officer April. You have failed to detain the criminal.",
	"This lapse will be recorded in my combat logs.",
	"Let us proceed."
]

@export var telitz_walk_point: Node2D

var april: Player
var cube: Player
var sprite: Sprite2D

@onready var telitz_denz = owner as Npc


func enter(_msg := {}) -> void:
	sprite = telitz_denz.sprite
	april = PartyManager.get_april() as Player
	cube = PartyManager.get_cube() as Player
	
	telitz_denz.velocity_component.accelerate_to_point_and_stop(
		telitz_walk_point.global_position)
	await telitz_denz.velocity_component.arrived
	april.update_blend_position(Vector2.DOWN)
	telitz_denz.speak(TELITZ_LINES_1)
	await DialogueManager.finished_dialogue
	
	cube.update_blend_position(Vector2.DOWN)
	cube.speak(CUBE_LINES_2)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_3)
	await DialogueManager.finished_dialogue
	
	cube.speak(CUBE_LINES_4)
	await DialogueManager.finished_dialogue
	
	var direction = cube.global_position.direction_to(april.global_position)
	cube.update_blend_position(direction)
	april.update_blend_position(-direction)
	await get_tree().create_timer(0.5).timeout
	cube.speak(CUBE_LINES_5)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_6)
	await DialogueManager.finished_dialogue
	
	april.update_blend_position(Vector2.DOWN)
	april.speak(APRIL_LINES_7)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_8)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_9)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_10)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_11)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_12)
	await DialogueManager.finished_dialogue
	
	telitz_denz.despawn()
	await get_tree().create_timer(1.6).timeout
	
	cube.speak(CUBE_LINES_13)
	#await DialogueManager.finished_dialogue
	
	PopUp.open_party_instructions()
	
	april.state_machine.transition_to("Active")
