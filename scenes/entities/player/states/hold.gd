# hold.gd
extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity_component.stop()


func update(_delta: float) -> void:
	pass
