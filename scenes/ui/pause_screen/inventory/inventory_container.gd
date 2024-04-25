extends HBoxContainer

@onready var inventory_slots: Array = get_slots()


func _ready():
	Inventory.item_used.connect(on_item_used)
	Inventory.item_added.connect(on_item_used)
	GameEvents.inventory_item_detail_closed.connect(regrab_focus)
	PopUp.closed.connect(regrab_focus)
	%SwordSprite.visible = PlayerVariables.has_sword
	
	inventory_slots[0].grab_focus()


func get_slots():
	return $InventoryGrid.get_children()


func set_slots():
	for i in range(Inventory.items.size() - 1):
		inventory_slots[i].set_item(Inventory.items[i])


func regrab_focus():
	if PopUp.visible:
		return
	inventory_slots[0].grab_focus()
	get_tree().paused = true


func on_item_used():
	set_slots()


func on_item_added():
	set_slots()
