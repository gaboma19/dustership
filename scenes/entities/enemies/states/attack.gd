# attack.gd
extends EnemyState

@onready var attack_range_area: Area2D = %AttackRangeArea

@export var enemy_attack: EnemyAttack


func enter(_msg := {}) -> void:
	enemy.velocity_component.stop()
	attack_range_area.body_exited.connect(on_attack_range_body_exited)


func update(_delta: float):
	if enemy_attack.cooldown_timer.is_stopped():
		enemy_attack.attack()
		enemy_attack.cooldown_timer.start()
	
	
func exit():
	attack_range_area.body_exited.disconnect(on_attack_range_body_exited)
	

func on_attack_range_body_exited(_body: Node2D):
	state_machine.transition_to("Aggro")
