extends Node2D

@export var telitz_missile_scene: PackedScene

@onready var left_node: Node2D = $Left
@onready var right_node: Node2D = $Right
@onready var left_timer: Timer = $Left/Timer
@onready var right_timer: Timer = $Right/Timer
@onready var attack_range: Area2D = $AttackRange

var entities_layer: Node2D


func _ready():
	left_timer.timeout.connect(spawn_missile.bind(left_node))
	right_timer.timeout.connect(spawn_missile.bind(right_node))
	
	entities_layer = get_tree().get_first_node_in_group("entities")


func start():
	spawn_missile(left_node)
	left_timer.start()
	await get_tree().create_timer(0.5).timeout
	spawn_missile(right_node)
	right_timer.start()


func stop():
	left_timer.stop()
	right_timer.stop()


func spawn_missile(node: Node2D):
	var missile = telitz_missile_scene.instantiate()
	var target = get_nearest_enemy()
	
	if target != null:
		missile.start(node.transform, target)
		entities_layer.add_child(missile)
		missile.global_position = node.global_position


func get_nearest_enemy():
	var nearby_enemies = attack_range.get_overlapping_bodies()
	nearby_enemies = nearby_enemies.filter(remove_spawn_state_enemies)
	nearby_enemies.sort_custom(sort_by_distance)
	
	if nearby_enemies.is_empty():
		return null
	return nearby_enemies[0]


func sort_by_distance(body1, body2):
	var body1_to_self = self.global_position.distance_to(body1.global_position)
	var body2_to_self = self.global_position.distance_to(body2.global_position)
	return body1_to_self < body2_to_self


func remove_spawn_state_enemies(enemy: Node2D):
	var enemy_state = (enemy as Enemy).state_machine.state.name
	
	if enemy_state == "Spawn":
		return false
	else:
		return true
