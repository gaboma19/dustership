extends Button

var item: InventoryItem

@onready var reference_rect = $ReferenceRect


func _ready():
	pressed.connect(on_pressed)


func set_item(new_item: InventoryItem):
	if new_item != null:
		set_button_icon(new_item.texture)
		item = new_item
	else:
		set_button_icon(null)
		item = null


func on_pressed():
	if item != null:
		item.use()
