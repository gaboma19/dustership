extends StaticBody2D

@onready var animation_player = $AnimationPlayer


func _ready():
	var delay = randf_range(0.0, 0.4)
	await get_tree().create_timer(delay).timeout
	
	var random_speed_scale = randf_range(0.4, 0.6)
	animation_player.speed_scale = random_speed_scale
	animation_player.play("default")
