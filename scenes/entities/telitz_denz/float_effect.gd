extends Node2D

@onready var animation_player = $AnimationPlayer


func play():
	animation_player.play("default")
