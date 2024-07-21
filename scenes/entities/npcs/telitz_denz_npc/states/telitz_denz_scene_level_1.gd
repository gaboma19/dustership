extends State

const TELITZ_LINES_1: Array[String] = [
	"Hello, April. Welcome to the Echelon.",
]

const APRIL_LINES_1: Array[String] = [
	"Telitz Denz. I didn't expect to meet the ring leader.",
	"There's a bounty on your head, you know. 40 million steel."
]

const TELITZ_LINES_2: Array[String] = [
	"I believe the contract you are referring to expired years ago.",
	"The bounty you seek was here not long ago."
]

const APRIL_LINES_2: Array[String] = [
	"So this is it? The Echelon?"
]

const TELITZ_LINES_3: Array[String] = [
	"Yes... still alive and functioning.",
	"The most perfect simulation of a universe ever created and ever will be created.",
	"Perfect to the subatomic level."
]

const TELITZ_LINES_4: Array[String] = [
	"But, the Echelon has accumulated... glitches in its programming."
]

const APRIL_LINES_4: Array[String] = [
	"Glitches?"
]

const TELITZ_LINES_5: Array[String] = [
	"Fiends. Glitch monsters.",
	"Transformed from the lost and long decaying souls that once inhabited this world.",
	"Will you help the Remembrancers and I to destroy them?"
]

const APRIL_LINES_YES: Array[String] = [
	"Sure. Just add it to my tab."
]

const APRIL_LINES_NO: Array[String] = [
	"That wasn't in the contract."
]

const TELITZ_LINES_YES: Array[String] = [
	"Excellent. I assure you, you will be paid handsomely for your assistance.",
	"I believe our interests align more closely than you have yet realized."
]

const TELITZ_LINES_NO: Array[String] = [
	"Think it over. I can assure you, you will be paid handsomely for your assistance.",
	"Our interests align more closely than you have yet realized."
]

var april: Player
var sprite: Sprite2D

@onready var telitz_denz = owner as Npc


func enter(_msg := {}) -> void:
	sprite = telitz_denz.sprite
	april = PartyManager.get_april()
	
	april.update_blend_position(Vector2.UP)
	telitz_denz.speak(TELITZ_LINES_1)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_1)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_2)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_2)
	await DialogueManager.finished_dialogue
	
	telitz_denz.update_blend_position(Vector2.LEFT)
	await get_tree().create_timer(0.1).timeout
	telitz_denz.update_blend_position(Vector2.UP)
	telitz_denz.speak(TELITZ_LINES_3)
	await DialogueManager.finished_dialogue
	
	telitz_denz.update_blend_position(Vector2.DOWN)
	telitz_denz.speak(TELITZ_LINES_4)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_4)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_5)
	await DialogueManager.finished_dialogue
	
	PopUp.open_decision_container("Will you help Telitz Denz?")
	PopUp.closed.connect(on_decision_container_closed)


func on_decision_container_closed(msg: String):
	if msg == "Yes":
		april.speak(APRIL_LINES_YES)
		await DialogueManager.finished_dialogue
		
		telitz_denz.speak(TELITZ_LINES_YES)
	elif msg == "No":
		april.speak(APRIL_LINES_NO)
		await DialogueManager.finished_dialogue
		
		telitz_denz.speak(TELITZ_LINES_NO)
	
	await DialogueManager.finished_dialogue
	april.state_machine.transition_to("Active")
	telitz_denz.despawn()
