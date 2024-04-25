extends Node

signal item_used
signal item_added

const SIZE: int = 12

var items: Array[InventoryItem]

func _ready():
	items.resize(SIZE)
	items.fill(null)


func add_item(item: InventoryItem):
	var index = items.find(null)
	if index != -1:
		items[index] = item
		item_added.emit()


func use_item(item: InventoryItem) -> bool:
	var index = items.find(item)
	if index != -1:
		items[index] = null
		item_used.emit()
		return true
	else:
		return false


func use_item_by_name(item_name: String) -> bool:
	var filtered_items = items.filter(func(item): return item.name == item_name)
	if filtered_items.is_empty():
		return false
	else:
		return filtered_items[0]
