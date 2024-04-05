extends Node2D

const KEY: InventoryItem = preload("res://resources/inventory_item/items/key.tres")

@onready var interaction_area = $InteractionArea
@onready var left_animation_player: AnimationPlayer = $EchelonDoorLeft.get_node("AnimationPlayer")
@onready var right_animation_player: AnimationPlayer = $EchelonDoorRight.get_node("AnimationPlayer")

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")

func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	var has_key = Inventory.use_item(KEY)
	if has_key:
		left_animation_player.play("open")
		right_animation_player.play("open")
		interaction_area.monitoring = false
	else:
		var floating_text = floating_text_scene.instantiate() as Node2D
		get_tree().get_first_node_in_group("foreground").add_child(floating_text)
		floating_text.global_position = global_position + (Vector2.UP * 16)
		floating_text.start("The door is locked.")
