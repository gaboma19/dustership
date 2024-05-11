# cactus_knight_idle.gd
extends EnemyState


func update(_delta: float) -> void:
	enemy.velocity_component.decelerate()
	enemy.velocity_component.move(enemy)
