extends Node2D

@onready var interaction_area = $InteractionArea
@export var inventory_item: InventoryItem


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	Inventory.add_item(inventory_item)
	queue_free()
