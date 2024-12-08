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
@onready var hud: CanvasLayer = get_parent()


func _ready():
	Inventory.item_used.connect(on_item_used)
	Inventory.item_added.connect(on_item_added)
	hud.visibility_changed.connect(on_visibility_changed)
	
	#_test_inventory()


func _unhandled_input(event):
	var index: int
	if event.is_action_pressed("item_1"):
		index = 0
	elif event.is_action_pressed("item_2"):
		index = 1
	elif event.is_action_pressed("item_3"):
		index = 2
	elif event.is_action_pressed("item_4"):
		index = 3
	else:
		return
	
	get_tree().root.set_input_as_handled()
	inventory_buttons[index].use_item()
	Inventory.use_item_by_index(index)


func set_slots():
	for i in range(Inventory.SIZE):
		inventory_buttons[i].set_item(Inventory.items[i])


func on_item_used():
	set_slots()


func on_item_added():
	set_slots()


func on_visibility_changed():
	visible = hud.visible


func _test_inventory():
	var grenade = load("res://resources/inventory_item/items/grenade.tres")
	var ammo = load("res://resources/inventory_item/items/ammo.tres")
	var magnet = load("res://resources/inventory_item/items/magnet.tres")
	var tonic = load("res://resources/inventory_item/items/tonic.tres")
	
	Inventory.add_item(grenade)
	Inventory.add_item(ammo)
	Inventory.add_item(magnet)
	Inventory.add_item(tonic)
