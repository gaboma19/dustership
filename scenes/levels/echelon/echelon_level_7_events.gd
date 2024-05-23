extends Node

const CUBE_LINES: Array[String] = [
	"Commander, hostile signature detected."
]
const APRIL_LINES: Array[String] = [
	"That's trouble."
]
const CUBE_LINES_2: Array[String] = [
	"Hostile eliminated.", 
	"Commander, I'm pleased to report that you've been granted 200 experience points."
]
const APRIL_LINES_2: Array[String] = [
	"You what."
]
const CUBE_LINES_3: Array[String] = [
	"You have accrued 780 experience points thus far, Commander.",
	"Based on your performance, you have been placed on the remedial combat training track."
]
const APRIL_LINES_3: Array[String] = [
	"Remedial???"
]
const CUBE_LINES_4: Array[String] = [
	"I will be tracking your progress, Commander.",
	"If you'd like to know your current experience point total, just say \"Hey Cube, XP\"."
]
const APRIL_LINES_4: Array[String] = [
	"I won't."
]
const PHILO_SCENE = preload("res://scenes/entities/enemies/philo/philo.tscn")
const CACTUS_KNIGHT_SCENE = preload(
	"res://scenes/entities/enemies/cactus_knight/cactus_knight.tscn")

@export var boss_door_1: Node2D
@export var boss_door_2: Node2D

var cube: Player
var april: Player
var philo_spawn_points: Array[Node]

@onready var spawn_points_parent = $SpawnPointsParent
@onready var boss_platform = $BossPlatform
@onready var trap_area = $TrapArea
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	set_philo_spawn_points()
	trap_area.body_entered.connect(on_body_entered_trap)


func set_philo_spawn_points():
	philo_spawn_points = spawn_points_parent.get_children()
	philo_spawn_points.shuffle()


func spawn_philo():
	if philo_spawn_points.is_empty():
		set_philo_spawn_points()
	
	var player = PartyManager.get_active_member()
	philo_spawn_points.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance > b_distance
	)
	var point = philo_spawn_points[0]
		
	var philo = PHILO_SCENE.instantiate()
	entities_layer.call_deferred("add_child", philo)
	philo.global_position = point.global_position
	
	await philo.ready
	
	var heart_drop_component = philo.get_node("HeartDropComponent")
	heart_drop_component.drop_percent = 1.0
	
	var state_machine = philo.get_node("StateMachine")
	state_machine.transition_to("Spawn")


func on_body_entered_trap(player: Player):
	trap_area.set_deferred("monitoring", false)
	
	player.state_machine.transition_to("Hold")
	PartyManager.disable_switch_character(true)

	cube = PartyManager.get_cube()
	april = PartyManager.get_april()
	
	cube.speak(CUBE_LINES)
	await DialogueManager.finished_dialogue
	
	var face_direction = april.global_position.direction_to(
		boss_door_1.global_position)
	april.update_blend_position(face_direction)
	
	boss_door_1.close()
	boss_door_1.set_interactable(false)
	boss_door_2.set_interactable(false)
	
	var cactus_knight = CACTUS_KNIGHT_SCENE.instantiate()
	entities_layer.call_deferred("add_child", cactus_knight)
	cactus_knight.global_position = boss_platform.global_position
	
	await cactus_knight.ready
	
	var health_component = cactus_knight.get_node("HealthComponent")
	health_component.died.connect(on_cactus_knight_died)
	
	var state_machine = cactus_knight.get_node("StateMachine")
	
	april.speak(APRIL_LINES)
	await DialogueManager.finished_dialogue
	
	player.state_machine.transition_to("Active")
	PartyManager.disable_switch_character(false)
	
	await get_tree().create_timer(0.5).timeout
	state_machine.transition_to("Shoot")


func on_cactus_knight_died():
	boss_door_1.open()
	boss_door_2.set_interactable(true)
	
	cube.speak(CUBE_LINES_2)
	await DialogueManager.finished_dialogue
	april.speak(APRIL_LINES_2)
	await DialogueManager.finished_dialogue
	cube.speak(CUBE_LINES_3)
	await DialogueManager.finished_dialogue
	april.speak(APRIL_LINES_3)
	await DialogueManager.finished_dialogue
	cube.speak(CUBE_LINES_4)
	await DialogueManager.finished_dialogue
	april.speak(APRIL_LINES_4)
