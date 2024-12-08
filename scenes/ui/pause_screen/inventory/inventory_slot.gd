extends Button

var item: InventoryItem
var inventory_item_detail_scene = preload(
	"res://scenes/ui/pause_screen/inventory/inventory_item_detail.tscn")


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
	# TODO: swap item positions with another slot
	pass
	
	#if item == null:
		#return
	#
	#var inventory_item_detail = inventory_item_detail_scene.instantiate()
	#inventory_item_detail.item = item
	#get_tree().get_first_node_in_group("top_margin_container").add_child(
		#inventory_item_detail)
