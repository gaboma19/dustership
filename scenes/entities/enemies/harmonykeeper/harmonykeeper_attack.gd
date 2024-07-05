# harmonykeeper_attack.gd
extends EnemyState

@export var attack_range_area: Area2D


func enter(_msg := {}) -> void:
	if not attack_range_area.body_exited.is_connected(on_attack_range_body_exited):
		attack_range_area.body_exited.connect(on_attack_range_body_exited)
	
	enemy.velocity_component.stop()
	enemy.set_attacking(true)
	shoot()


func shoot():
	pass


func on_attack_range_body_exited(_body: Node2D):
	print("why")
	enemy.set_attacking(false)
	state_machine.transition_to("Aggro")
