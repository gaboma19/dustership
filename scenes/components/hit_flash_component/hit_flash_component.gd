extends Node

const HIT_FLASH_MATERIAL = preload("res://resources/materials/hit_flash_material.tres")

@export var health_component: Node
@export var sprite: Sprite2D

var hit_flash_tween: Tween


func _ready():
	health_component.health_changed.connect(on_health_changed)
	set_sprite_material()


func set_sprite_material():
	# duplicate the resource, checking "local to scene" didn't work
	var material = HIT_FLASH_MATERIAL.duplicate()
	sprite.material = material
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 0)


func set_connected(value: bool):
	if value:
		health_component.health_changed.connect(on_health_changed)
	else:
		health_component.health_changed.disconnect(on_health_changed)


func on_health_changed():
	# restart tween if it is already active
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.25)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
