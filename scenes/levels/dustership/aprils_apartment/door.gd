extends Sprite2D

@onready var animation_area: Area2D = $AnimationArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	animation_area.body_entered.connect(on_body_entered)
	animation_area.body_exited.connect(on_body_exited)


func on_body_entered(_body):
	animation_player.play("open")


func on_body_exited(_body):
	animation_player.play_backwards("open")
