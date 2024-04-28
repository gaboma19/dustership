extends Resource
class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var is_usable: bool
@export_multiline var description: String
@export var pop_up_text: String


func use():
	pass
