extends Button

var item: InventoryItem


func _ready():
	pressed.connect(on_pressed)


func use_item():
	item.use()


func set_item(new_item: InventoryItem):
	if new_item != null:
		set_button_icon(new_item.texture)
		item = new_item
	else:
		set_button_icon(null)
		item = null


func on_pressed():
	use_item()
