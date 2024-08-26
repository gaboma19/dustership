extends Node2D

@onready var animation_player = $AnimationPlayer


func move_up():
	animation_player.play("move_up")


func reset():
	animation_player.stop()
