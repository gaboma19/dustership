extends Node2D

signal enemies_cleared

@export var chest: DungeonChest
@export var spawn_points_parent: Node

@export_group("Enemy Scenes")
@export var philo_scene: PackedScene
@export var raster_scene: PackedScene
@export var saguaro_scene: PackedScene
@export var tumbleweed_scene: PackedScene

@export_group("InventoryItem Rewards")
@export var magnet: InventoryItem
@export var grenade: InventoryItem
@export var tonic: InventoryItem
@export var ammo: InventoryItem

var number_dead_enemies: int = 0
var total_enemies: int = 0

@onready var enemy_max_count = {
	philo_scene: 4,
	raster_scene: 2,
	saguaro_scene: 2,
	tumbleweed_scene: 1
}
@onready var spawn_points = spawn_points_parent.get_children()
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	spawn_points.shuffle()


func build(room: Room):
	chest.build(room.chest_id)


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


func get_random_scene() -> PackedScene:
	const PHILO_CHANCE: int = 60
	const RASTER_CHANCE: int = 17
	const SAGUARO_CHANCE: int = 17
	const _TUMBLEWEED_CHANCE: int = 6
	
	var rnd = randi() % 100
	if rnd < PHILO_CHANCE:
		return philo_scene
	if rnd < PHILO_CHANCE + RASTER_CHANCE:
		return raster_scene
	if rnd < PHILO_CHANCE + RASTER_CHANCE + SAGUARO_CHANCE:
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


func spawn_chest():
	chest.show()
	chest.inventory_item = get_random_reward()
	chest.spawn()


func get_random_reward() -> InventoryItem:
	const MAGNET_CHANCE: int = 20
	const GRENADE_CHANCE: int = 20
	const AMMO_CHANCE: int = 20
	const TONIC_CHANCE: int = 20
	const _EMPTY_CHANCE: int = 20
	
	var rnd = randi() % 100
	if rnd < MAGNET_CHANCE:
		return magnet
	if rnd < MAGNET_CHANCE + GRENADE_CHANCE:
		return grenade
	if rnd < MAGNET_CHANCE + GRENADE_CHANCE + AMMO_CHANCE:
		return ammo
	if rnd < MAGNET_CHANCE + GRENADE_CHANCE + AMMO_CHANCE + TONIC_CHANCE:
		return tonic
	else:
		return null


func on_enemy_died():
	number_dead_enemies += 1
	if number_dead_enemies >= total_enemies:
		enemies_cleared.emit()
