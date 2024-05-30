extends StaticBody2D

signal opened

const TEXTURE = preload("res://assets/chest/chest.png")

@export var inventory_item: InventoryItem
@export var chest_id: String

@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var spawn_material: ShaderMaterial = preload(
	"res://resources/materials/spawn_material.tres")


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


func spawn():
	var sprite = $AnimatedSprite2D
	sprite.material = spawn_material
	(sprite.material as ShaderMaterial).set_shader_parameter(
		"dissolve_texture", TEXTURE)
	sprite.scale = Vector2(3, 3)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite.material, "shader_parameter/dissolve_value", 0, 0)
	tween.chain()
	tween.tween_property(sprite.material, "shader_parameter/dissolve_value", 1.0, 1.6)
	tween.tween_property(sprite, "scale", Vector2.ONE, 1.6)
	tween.chain()


func on_interact():
	EntityVariables.chests[chest_id].opened = true
	
	$AudioStreamPlayer2D.play()
	animated_sprite_2d.play()
	
	interaction_area.monitoring = false
	
	if inventory_item == null:
		return
	
	await get_tree().create_timer(0.4).timeout
	
	if inventory_item.name == "sword":
		PlayerVariables.has_sword = true
		PopUp.set_sword_instructions()
		PopUp.open_pop_up(inventory_item)
		return
	
	PopUp.open_pop_up(inventory_item)
	
	Inventory.add_item(inventory_item)
	
	opened.emit()
