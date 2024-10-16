extends Node

signal enemies_cleared

@export var philo_scene: PackedScene
@export var raster_scene: PackedScene
@export var saguaro_scene: PackedScene
@export var chest_scene: PackedScene

var number_dead_enemies: int = 0
var total_enemies: int = 0

@onready var spawn_points: Array[Node] = get_children()
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	pass


func spawn_enemies():
	pass


func spawn_chest(reward: InventoryItem):
	var chest = chest_scene.instantiate()
	chest.inventory_item = reward
	chest.chest_id = DungeonManager.get_chest_id()
	entities_layer.add_child(chest)
	chest.spawn()


func spawn_opened_chest():
	var chest = chest_scene.instantiate()
	


func on_enemy_died():
	number_dead_enemies += 1
	if number_dead_enemies == total_enemies:
		enemies_cleared.emit()


	#var enemies = get_tree().get_nodes_in_group("enemy")
	#for e in enemies:
		#var health_component = e.get_node("HealthComponent")
		#health_component.died.connect(on_enemy_died)
	#
	#total_enemies = enemies.size()
