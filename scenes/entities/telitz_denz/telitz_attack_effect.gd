extends Node2D

var knockback_direction: Vector2

@onready var animation_player = $AnimationPlayer
@onready var knockbox_component = $KnockboxComponent


func _ready():
	knockbox_component.knockback_direction = knockback_direction
	
	await get_tree().create_timer(0.8).timeout
	queue_free()
