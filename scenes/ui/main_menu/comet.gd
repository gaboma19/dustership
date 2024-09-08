extends Sprite2D

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer


func _ready():
	timer.timeout.connect(on_timer_timeout)
	
	await get_tree().create_timer(4.0).timeout
	animation_player.play("default")


func on_timer_timeout():
	animation_player.play("default")
