extends Sprite2D
class_name StunComponent

const STUN_MATERIAL = preload("res://resources/materials/stun.tres")
const HIT_FLASH_MATERIAL = preload("res://resources/materials/hit_flash_material.tres")

@export var sprite: Sprite2D

var stun_duration: float


func start():
	$AnimationPlayer.play("flashes")
	sprite.material = STUN_MATERIAL


func end():
	$AnimationPlayer.play("big_flash")
	sprite.material = HIT_FLASH_MATERIAL
