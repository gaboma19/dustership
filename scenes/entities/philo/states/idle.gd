# idle.gd
extends EnemyState

@export var aggro_area: Area2D
@export var attack_range_area: Area2D


func enter(_msg := {}) -> void:
	aggro_area.body_entered.connect(on_aggro_body_entered)
	attack_range_area.body_entered.connect(on_attack_range_body_entered)


func update(_delta: float) -> void:
	enemy.velocity_component.decelerate()
	enemy.velocity_component.move(enemy)


func exit():
	aggro_area.body_entered.disconnect(on_aggro_body_entered)
	attack_range_area.body_entered.disconnect(on_attack_range_body_entered)


func on_aggro_body_entered(_body: Node2D):
	state_machine.transition_to("Aggro")
	
	
func on_attack_range_body_entered(_body: Node2D):
	state_machine.transition_to("Attack")
