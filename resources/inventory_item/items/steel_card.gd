extends InventoryItem


func use():
	GameEvents.emit_steel_collected(200)
	Inventory.use_item(self)
	
