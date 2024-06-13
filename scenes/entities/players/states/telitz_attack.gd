# telitz_attack.gd
extends PlayerState


func enter(_msg := {}) -> void:
	PartyManager.disable_switch_character(true)
	player.set_moving(false)
	player.set_attacking(true)
	player.velocity_component.stop()
	
	await get_tree().create_timer(0.6).timeout
	transition_to_active()


func transition_to_active():
	PartyManager.disable_switch_character(false)
	player.set_attacking(false)
	player.set_moving(false)
	state_machine.transition_to("Active")
