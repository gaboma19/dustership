# cactus_knight_idle.gd
extends EnemyState


func enter(_msg := {}) -> void:
	pass


func update(_delta: float) -> void:
	enemy.velocity_component.decelerate()
	enemy.velocity_component.move(enemy)
