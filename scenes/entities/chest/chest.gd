extends StaticBody2D

signal opened

@export var inventory_item: InventoryItem

@export var chest_id: String
@export var pop_up_text: String

@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var pop_up_scene = preload("res://scenes/ui/pop_up/pop_up.tscn")


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if EntityVariables.chests.has(chest_id):
		set_opened(EntityVariables.chests[chest_id].opened)
	else:
		EntityVariables.chests[chest_id] = { "opened": false }


func set_opened(value: bool):
	if value:
		animated_sprite_2d.set_frame(1)
		interaction_area.monitoring = false


func on_interact():
	EntityVariables.chests[chest_id].opened = true
	
	animated_sprite_2d.play()
	interaction_area.monitoring = false
	
	if inventory_item == null:
		return
	
	await get_tree().create_timer(0.4).timeout
	var pop_up = pop_up_scene.instantiate()
	get_tree().root.add_child(pop_up)
	
	if pop_up_text.is_empty():
		pop_up.set_pop_up(inventory_item)
	else:
		pop_up.set_pop_up(inventory_item, pop_up_text)
	
	if inventory_item.name == "sword":
		PlayerVariables.has_sword = true
		pop_up.set_sword_instructions()
		return
	
	Inventory.add_item(inventory_item)
	opened.emit()
