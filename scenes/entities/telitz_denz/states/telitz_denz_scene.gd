extends State

const TELITZ_LINES_1: Array[String] = [
	"Hello, April. Welcome to the Echelon.",
	"Do you know who I am?"
]

const APRIL_LINES_1: Array[String] = [
	"You're Telitz Denz.",
	"There's a bounty on your head. 40 million steel."
]

const TELITZ_LINES_2: Array[String] = [
	"I believe the contract you are referring to expired years ago.",
	"Even so, there's no way to capture me from the Echelon, April."
]

const APRIL_LINES_2: Array[String] = [
	"This is the Echelon? How is that possible?"
]

const TELITZ_LINES_3: Array[String] = [
	"Yes... the Echelon is still alive and functioning.",
	"The most perfect simulation of a universe ever created and ever will be created.",
	"Perfect to the subatomic level."
]

const APRIL_LINES_3: Array[String] = [
	"How do you know who I am?"
]

const TELITZ_LINES_4: Array[String] = [
	"The truth is April, I brought you here.",
	"It's not often I find someone so well attuned to meta-dimensional space.",
	"And we could use someone with your combat prowess.",
	"The Echelon, in its centuries of dormancy, has accumulated glitches in its programming."
]

const APRIL_LINES_4: Array[String] = [
	"Glitches?"
]

const TELITZ_LINES_5: Array[String] = [
	"Fiends. Glitch monsters.",
	"Transformed from the lost and long decaying souls that once inhabited this world.",
	"Will you help us destroy them?"
]

const APRIL_LINES_YES: Array[String] = [
	"Sure... yeah. I had a lot of time to kill in the real world, anyway."
]

const APRIL_LINES_NO: Array[String] = [
	"Saving an ancient and forbidden virtual reality isn't really on my to-do list."
]

const TELITZ_LINES_YES: Array[String] = [
	"Excellent.",
	"I believe our interests align more closely than you have yet realized."
]

const TELITZ_LINES_NO: Array[String] = [
	"Think it over.",
	"Our interests align more closely than you have yet realized."
]

var april: Player
var sprite: Sprite2D

@onready var telitz_denz = owner as Npc


func enter(_msg := {}) -> void:
	sprite = telitz_denz.sprite
	
	april = PartyManager.get_april()
	
	telitz_denz.speak(TELITZ_LINES_1)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_1)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_2)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_2)
	await DialogueManager.finished_dialogue
	
	telitz_denz.update_blend_position(Vector2.UP)
	telitz_denz.speak(TELITZ_LINES_3)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_3)
	await DialogueManager.finished_dialogue
	
	telitz_denz.update_blend_position(Vector2.DOWN)
	telitz_denz.speak(TELITZ_LINES_4)
	await DialogueManager.finished_dialogue
	
	april.speak(APRIL_LINES_4)
	await DialogueManager.finished_dialogue
	
	telitz_denz.speak(TELITZ_LINES_5)
	await DialogueManager.finished_dialogue
	
	PopUp.open_decision_container()
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
	despawn()


func despawn():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite.material, "shader_parameter/alpha", 0, 1.6)
	tween.tween_property(sprite.material, "shader_parameter/effect_factor", 1, 1.6)
	tween.tween_property(sprite.material, "shader_parameter/noise_amount", 1, 1.6)
	tween.tween_property(sprite, "scale", Vector2(3, 3), 1.6)
	tween.chain()
	tween.tween_callback(telitz_denz.queue_free)
