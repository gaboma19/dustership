# spawn.gd
extends EnemyState

@onready var spawn_material: ShaderMaterial = preload(
	"res://resources/materials/spawn_material.tres")
@onready var sprite = %Sprite2D
@onready var hurtbox_component = %HurtboxComponent


func enter(_msg := {}) -> void:
	sprite.material = spawn_material
	(sprite.material as ShaderMaterial).set_shader_parameter(
		"shader_parameter/dissolve_texture", sprite.texture)
	sprite.scale = Vector2(3, 3)
	hurtbox_component.monitoring = false
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite.material, "shader_parameter/dissolve_value", 0, 0)
	tween.chain()
	tween.tween_property(sprite.material, "shader_parameter/dissolve_value", 1.0, 1.6)
	tween.tween_property(sprite, "scale", Vector2.ONE, 1.6)
	tween.chain()
	tween.tween_callback(on_tween_callback)


func on_tween_callback():
	if enemy.has_node("HitFlashComponent"):
		var hit_flash_component = enemy.get_node("HitFlashComponent")
		hit_flash_component.set_sprite_material()
	hurtbox_component.monitoring = true
	
	state_machine.transition_to("Idle")
