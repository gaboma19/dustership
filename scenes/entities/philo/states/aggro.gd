# aggro.gd
extends EnemyState

@export var aggro_area: Area2D
@export var attack_range_area: Area2D


func enter(_msg := {}) -> void:
	if not aggro_area.body_exited.is_connected(on_body_exited):
		aggro_area.body_exited.connect(on_body_exited)
	if not attack_range_area.body_entered.is_connected(on_attack_range_body_entered):
		attack_range_area.body_entered.connect(on_attack_range_body_entered)


func update(_delta: float) -> void:
	if enemy.player == null:
		return
	enemy.velocity_component.accelerate_to_player()
	enemy.velocity_component.move(enemy)


func on_body_exited(_body: Node2D):
	state_machine.transition_to("Idle")


func on_attack_range_body_entered(_body: Node2D):
	state_machine.transition_to("Attack")
