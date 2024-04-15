extends StaticBody2D

@export var inventory_item: InventoryItem

@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var pop_up_scene = preload("res://scenes/ui/pop_up/pop_up.tscn")


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	animated_sprite_2d.play()
	interaction_area.monitoring = false
	
	if inventory_item == null:
		return
	
	Inventory.add_item(inventory_item)
	
	await get_tree().create_timer(0.4).timeout
	var pop_up = pop_up_scene.instantiate()
	get_tree().root.add_child(pop_up)
	pop_up.set_pop_up(inventory_item)
