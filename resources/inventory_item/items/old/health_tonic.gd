# health_tonic.gd
extends InventoryItem


func use():
	PlayerVariables.heal(5)
	Inventory.use_item(self)
