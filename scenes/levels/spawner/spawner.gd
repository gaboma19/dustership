extends Node

signal enemies_cleared

@export var philo_scene: PackedScene
@export var raster_scene: PackedScene
@export var saguaro_scene: PackedScene
@export var chest: StaticBody2D
@export var spawn_points_parent: Node

var number_dead_enemies: int = 0
var total_enemies: int = 0

@onready var spawn_points: Array[Node] = spawn_points_parent.get_children()
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	pass


func spawn_enemies():
	pass


func spawn_chest(reward: InventoryItem):
	chest.show()
	chest.inventory_item = reward
	chest.chest_id = DungeonManager.get_chest_id()
	entities_layer.add_child(chest)
	chest.spawn()


func on_enemy_died():
	number_dead_enemies += 1
	if number_dead_enemies == total_enemies:
		enemies_cleared.emit()
