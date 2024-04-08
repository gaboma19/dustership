# hold.gd
extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity_component.stop()
	player.set_moving(false)
