# key.gd
extends InventoryItem


func use():
	Inventory.use_item(self)
