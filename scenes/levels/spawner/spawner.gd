extends Node2D

signal enemies_cleared

@export var philo_scene: PackedScene
@export var raster_scene: PackedScene
@export var saguaro_scene: PackedScene
@export var chest: Chest
@export var spawn_points_parent: Node

var number_dead_enemies: int = 0
var total_enemies: int = 0

@onready var enemy_max_number = {
	philo_scene: 6,
	raster_scene: 1,
	saguaro_scene: 2
}
@onready var spawn_points = spawn_points_parent.get_children()
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	spawn_points.shuffle()


func spawn_enemies():
	var wave_size = 4
	for i in wave_size:
		var scene = get_random_scene()
		var spawn_point = spawn_points[i % spawn_points.size()]
		var number = randi_range(1, enemy_max_number[scene])
		spawn_scene(scene, number, spawn_point)


func get_random_scene():
	var rnd = randi() % 100
	if rnd < 50:
		return philo_scene
	if rnd < 75:
		return raster_scene
	else:
		return saguaro_scene


func spawn_scene(scene: PackedScene, number: int, spawn_point: Node2D):
	for n in number:
		total_enemies += 1
		
		var enemy = scene.instantiate()
		entities_layer.add_child(enemy)
		
		enemy.global_position = spawn_point.global_position
		
		var health_component = enemy.get_node("HealthComponent")
		health_component.died.connect(on_enemy_died)
		
		var state_machine = enemy.get_node("StateMachine")
		state_machine.transition_to("Spawn")


func spawn_chest(reward: InventoryItem):
	chest.show()
	chest.inventory_item = reward
	chest.spawn()


func on_enemy_died():
	number_dead_enemies += 1
	if number_dead_enemies >= total_enemies:
		enemies_cleared.emit()
