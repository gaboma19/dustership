extends Node2D

signal enemies_cleared

@export var philo_scene: PackedScene
@export var raster_scene: PackedScene
@export var saguaro_scene: PackedScene
@export var tumbleweed_scene: PackedScene
@export var chest: Chest
@export var spawn_points_parent: Node

var number_dead_enemies: int = 0
var total_enemies: int = 0

@onready var enemy_max_count = {
	philo_scene: 6,
	raster_scene: 1,
	saguaro_scene: 2,
	tumbleweed_scene: 1
}
@onready var spawn_points = spawn_points_parent.get_children()
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	spawn_points.shuffle()


func spawn_enemies(wave_size: int = 4):
	var spawn_list: Array[PackedScene]
	
	for i in wave_size:
		var scene = get_random_scene()
		var count = randi_range(1, enemy_max_count[scene])
		for j in range(count):
			spawn_list.append(scene)
	
	for k in range(spawn_list.size()):
		var spawn_point = spawn_points[k % spawn_points.size()]
		spawn_scene(spawn_list[k], spawn_point)


func get_random_scene():
	var rnd = randi() % 100
	if rnd < 60:
		return philo_scene
	if rnd < 79:
		return raster_scene
	if rnd < 98:
		return saguaro_scene
	else:
		return tumbleweed_scene


func spawn_scene(scene: PackedScene, spawn_point: Node2D):
	var entity = scene.instantiate()
	entities_layer.add_child(entity)
	
	entity.global_position = spawn_point.global_position
	
	if entity is Enemy:
		total_enemies += 1
		
		var health_component = entity.get_node("HealthComponent")
		health_component.died.connect(on_enemy_died)
	
		var state_machine = entity.get_node("StateMachine")
		state_machine.transition_to("Spawn")


func spawn_chest(reward: InventoryItem):
	chest.show()
	chest.inventory_item = reward
	chest.spawn()


func on_enemy_died():
	number_dead_enemies += 1
	if number_dead_enemies >= total_enemies:
		enemies_cleared.emit()
