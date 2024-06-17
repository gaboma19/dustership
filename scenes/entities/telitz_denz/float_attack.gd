extends Node2D

const TELITZ_MISSILE_SCENE = preload(
	"res://scenes/entities/telitz_denz/telitz_missile.tscn")

@onready var left_node = $Left
@onready var right_node = $Right
@onready var left_timer: Timer = $Left/Timer
@onready var right_timer: Timer = $Right/Timer

var entities_layer: Node2D


func start():
	left_timer.timeout.connect(spawn_left_missile)
	right_timer.timeout.connect(spawn_right_missile)
	
	entities_layer = get_tree().get_first_node_in_group("entities")
	
	spawn_left_missile()
	left_timer.start()
	await get_tree().create_timer(0.5).timeout
	spawn_right_missile()
	right_timer.start()


func spawn_left_missile():
	var missile = TELITZ_MISSILE_SCENE.instantiate()
	var target = get_nearest_enemy(left_node)
	missile.start(left_node.transform, target)


func spawn_right_missile():
	pass


func get_nearest_enemy(origin: Node2D):
	pass
