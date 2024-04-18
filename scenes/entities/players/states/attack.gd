# attack.gd
extends PlayerState

@onready var attack_timer: Timer = %AttackTimer


func enter(_msg := {}) -> void:
	var nudge_direction = player.velocity_component.velocity.normalized()
	
	player.velocity_component.stop()
	player.set_moving(false)
	player.set_attacking(true)
	
	attack_timer.start()
	
	await get_tree().create_timer(0.2).timeout
	player.move_and_collide(nudge_direction * 4)
	
	await attack_timer.timeout
	transition_to_active()


func transition_to_active():
	player.set_attacking(false)
	state_machine.transition_to("Active")
