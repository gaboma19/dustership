# april_attack.gd
extends PlayerState

var nudge_direction: Vector2

@onready var attack_timer: Timer = %AttackTimer
@onready var attack_combo_timer: Timer = %AttackComboTimer


func enter(_msg := {}) -> void:
	PartyManager.disable_switch_character(true)
	
	player.set_moving(false)
	player.set_attacking(true)
	
	nudge_direction = player.velocity_component.velocity.normalized()
	
	player.velocity_component.stop()
	
	attack_timer.start()
	await attack_timer.timeout
	transition_to_active()


func nudge():
	%SwordAudio.play_random()
	player.move_and_collide(nudge_direction * 5)


func transition_to_active():
	PartyManager.disable_switch_character(false)
	
	player.animation_tree.number_attacks += 1
	
	attack_combo_timer.stop()
	attack_combo_timer.start()
	
	player.set_attacking(false)
	
	state_machine.transition_to("Active")
