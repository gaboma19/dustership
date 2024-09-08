extends Sprite2D

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	animation_player.play("default")
