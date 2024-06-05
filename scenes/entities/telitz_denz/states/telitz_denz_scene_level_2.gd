extends State

const TELITZ_LINES_1: Array[String] = [
	"Ah hah, I see the friendly combat Cube is feeling better.",
	"I hope you've thanked our new friend April for fixing you."
]

const CUBE_LINES_1: Array[String] = [
	"Telitz Denz."
]

const APRIL_LINES_1: Array[String] = [
	""
]

@export var telitz_walk_point: Node2D

var april: Player
var cube: Player
var sprite: Sprite2D

@onready var telitz_denz = owner as Npc


func enter(_msg := {}) -> void:
	sprite = telitz_denz.sprite
	april = PartyManager.get_april()
	cube = PartyManager.get_cube()
	
	telitz_denz.velocity_component.accelerate_to_point_and_stop(
		telitz_walk_point.global_position)
	await telitz_denz.velocity_component.arrived
	april.update_blend_position(Vector2.DOWN)
