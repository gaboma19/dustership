extends Node2D

const KEY: InventoryItem = preload("res://resources/inventory_item/items/key.tres")

@export var door_id: String

var floating_text_scene = preload("res://scenes/ui/floating_text/floating_text.tscn")

@onready var interaction_area = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if EntityVariables.doors.has(door_id):
		set_opened(EntityVariables.doors[door_id].opened)
	else:
		EntityVariables.doors[door_id] = { "opened": false }


func set_opened(value: bool):
	if value:
		queue_free()


func on_interact():
	var has_key = Inventory.use_item(KEY)
	if has_key:
		EntityVariables.doors[door_id].opened = true
		animation_player.play("open")
		$AudioStreamPlayer2D.play()
		interaction_area.monitoring = false
	else:
		var floating_text = floating_text_scene.instantiate() as Node2D
		get_tree().get_first_node_in_group("foreground").add_child(floating_text)
		floating_text.global_position = global_position + (Vector2.UP * 16)
		floating_text.start("The door is locked.")
