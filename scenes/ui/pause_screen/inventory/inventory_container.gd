extends HBoxContainer


func _ready():
	%SwordSprite.visible = PlayerVariables.has_sword


func get_slots():
	return $InventoryGrid.get_children()
