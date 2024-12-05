extends CanvasLayer

@onready var inventory_button_1 = %InventoryButton1
@onready var inventory_button_2 = %InventoryButton2
@onready var inventory_button_3 = %InventoryButton3
@onready var inventory_button_4 = %InventoryButton4
@onready var inventory_buttons: Array = [
		inventory_button_1, 
		inventory_button_2, 
		inventory_button_3, 
		inventory_button_4
	]


func _ready():
	Inventory.item_used.connect(on_item_used)
	Inventory.item_added.connect(on_item_added)


func set_slots():
	for i in range(Inventory.items.size() - 1):
		inventory_buttons[i].set_item(Inventory.items[i])


func on_item_used():
	set_slots()


func on_item_added():
	set_slots()
