extends Area2D
class_name KnockboxComponent

@export var knockback_direction: Vector2


func _ready():
	knockback_direction = knockback_direction.normalized()
