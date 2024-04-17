# attack.gd
extends PlayerState

@onready var attack_timer: Timer = %AttackTimer

var movement_vector := Vector2.ZERO


func enter(_msg := {}) -> void:
	player.velocity_component.stop()
	player.set_moving(false)
	player.set_attacking(true)
	
	attack_timer.start()
	await attack_timer.timeout
	transition_to_active()


func transition_to_active():
	player.set_attacking(false)
	state_machine.transition_to("Active")
