extends State

const APRIL_LINES_1: Array[String] = [
	"This is so strange... I know this place.",
]

const TELITZ_LINES_1: Array[String] = [
	"We appear to be in a simulation of the planet Ammella.",
	"The properties of this area indicate that the simulated year is 1927."
]

const APRIL_LINES_2: Array[String] = [
	"Hm... that's the year I resigned from the Preservers."
]

const APRIL_LINES_2_1: Array[String] = [
	"Yeah, this is the back of my old apartment on Ammella.",
	"But why does the Echelon... have this place?"
]

const TELITZ_LINES_2: Array[String] = [
	"The Echelon has the ability to read and understand its users' memories.",
	"Your memories can then be simulated, with perfect precision and with maximum detail."
]

const APRIL_LINES_3: Array[String] = [
	"But why this memory? Why is it simulating my old apartment?",
]

const TELITZ_LINES_3: Array[String] = [
	"That is unknown. The Echelon's code hasn't been properly maintained for hundreds of years...", 
	"...so, it is prone to \"hallucinations\".",
	"This is a subject of ongoing research amongst my followers."
]

const APRIL_LINES_4: Array[String] = [
	"Your followers, eh?",
]

const TELITZ_LINES_4: Array[String] = [
	"Is this your car? It's an old Evo-212.",
	"Very impressive."
]

const APRIL_LINES_5: Array[String] = [
	"Yeah, and I ended up totaling this car the very next year.", 
	"But, this is back in the days when I had money.",
	"Speaking of which, isn't it past time we discussed my payment for cleaning up this place?"
]

const TELITZ_LINES_5: Array[String] = [
	"I must be going. We shall speak again soon.",
]

@onready var telitz_denz = owner as Npc

var april: Player
var sprite: Sprite2D

@export var telitz_walk_point: Node2D


func enter(_msg := {}) -> void:
	sprite = telitz_denz.sprite
	april = PartyManager.get_april()
	
	april.update_blend_position(Vector2.RIGHT)
	await get_tree().create_timer(1.0).timeout
	april.speak(APRIL_LINES_1)
	await DialogueManager.finished_dialogue
	
	telitz_denz.update_blend_position(Vector2.LEFT)
	await get_tree().create_timer(1.0).timeout
	telitz_denz.update_blend_position(Vector2.DOWN)
	await get_tree().create_timer(1.0).timeout
	telitz_denz.update_blend_position(Vector2.RIGHT)
	await get_tree().create_timer(1.0).timeout
	telitz_denz.update_blend_position(Vector2.LEFT)
	telitz_denz.speak(TELITZ_LINES_1)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_2)
	await DialogueManager.finished_dialogue
	april.update_blend_position(Vector2.LEFT)
	april.speak(APRIL_LINES_2_1)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_2)
	await DialogueManager.finished_dialogue
	
	april.update_blend_position(Vector2.RIGHT)
	april.speak(APRIL_LINES_3)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_3)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_4)
	await DialogueManager.finished_dialogue
	
	telitz_denz.velocity_component.accelerate_to_point_and_stop(
		telitz_walk_point.global_position)
	await telitz_denz.velocity_component.arrived
	april.update_blend_position(Vector2.LEFT)
	await get_tree().create_timer(1.0).timeout
	telitz_denz.speak(TELITZ_LINES_4)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_5)
	await DialogueManager.finished_dialogue
	
	telitz_denz.update_blend_position(Vector2.RIGHT)
	telitz_denz.speak(TELITZ_LINES_5)
	await DialogueManager.finished_dialogue

	april.state_machine.transition_to("Active")
	telitz_denz.despawn()
