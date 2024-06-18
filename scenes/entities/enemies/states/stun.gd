# stun.gd
extends EnemyState

var previous_state: String

@export var stun_component: StunComponent


func enter(msg := {}) -> void:
	if msg.is_empty():
		return
	if stun_component == null:
		return
	
	previous_state = msg.previous_state
	
	enemy.velocity_component.stop()
	enemy.set_moving(false)
	
	stun_component.start()
	enemy.set_stunned(true)
	
	await get_tree().create_timer(stun_component.stun_duration).timeout
	
	enemy.set_stunned(false)
	state_machine.transition_to(previous_state)


func exit():
	stun_component.end()
