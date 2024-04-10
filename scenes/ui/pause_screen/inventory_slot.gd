extends PanelContainer

@onready var texture_rect = $TextureRect


func set_item(item: InventoryItem):
	if not item:
		texture_rect.visible = false
	else:
		texture_rect.visible = true
		texture_rect.texture = item.texture
