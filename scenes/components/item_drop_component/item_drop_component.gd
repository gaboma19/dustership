extends Node

const ITEM_PICKUP_SCENE = preload(
	"res://scenes/entities/item_pickup/item_pickup.tscn")

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: HealthComponent
@export var item: InventoryItem


func _ready():
	health_component.died.connect(on_died)


func on_died():
	if not owner is Node2D:
		return
	
	if randf() > drop_percent:
		return
		
	var spawn_position = (owner as Node2D).global_position
	var item_pickup = ITEM_PICKUP_SCENE.instantiate()
	item_pickup.item = item
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(item_pickup)
	item_pickup.global_position = spawn_position
