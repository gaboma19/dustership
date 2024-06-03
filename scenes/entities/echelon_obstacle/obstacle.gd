extends StaticBody2D
class_name Obstacle

@onready var animation_player = $AnimationPlayer
@onready var collision_shape = $CollisionShape2D


func rise():
	var delay = randf_range(0.0, 0.4)
	await get_tree().create_timer(delay).timeout
	
	animation_player.play("rise")


func lower():
	var delay = randf_range(0.0, 0.4)
	await get_tree().create_timer(delay).timeout
	
	animation_player.play_backwards("lower")
