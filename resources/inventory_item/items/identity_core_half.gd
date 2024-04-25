extends InventoryItem

@export var other_half: String


func use():
	const IDENTITY_CORE = preload(
		"res://resources/inventory_item/items/identity_core.tres")

	if Inventory.use_item_by_name(other_half):
		Inventory.use_item(self)
		Inventory.add_item(IDENTITY_CORE)
		PopUp.open_pop_up(IDENTITY_CORE, "Crafted an identity core!")
	else:
		PopUp.open_pop_up(self, "Nothing happened. Missing a component.")
