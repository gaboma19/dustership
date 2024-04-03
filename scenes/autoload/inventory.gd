extends Node

const SIZE: int = 12

var items: Array[InventoryItem]

func _ready():
	items.resize(SIZE)
	items.fill(null)


func add_item(item: InventoryItem):
	var index = items.find(null)
	if index != -1:
		items[index] = item


func remove_item(item: InventoryItem):
	var index = items.find(item)
	if index != -1:
		items[index] = null
