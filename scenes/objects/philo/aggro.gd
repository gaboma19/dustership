# aggro.gd
extends EnemyState

@onready var aggro_area_2d = %AggroArea2D


func enter(_msg := {}) -> void:
	if not aggro_area_2d.body_exited.is_connected(on_body_exited):
		aggro_area_2d.body_exited.connect(on_body_exited)


func update(_delta: float) -> void:
	if enemy.player == null:
		return
	enemy.velocity_component.accelerate_to_player()
	enemy.velocity_component.move(enemy)


func on_body_exited(_body: Node2D):
	state_machine.transition_to("Idle")
