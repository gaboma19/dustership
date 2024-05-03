# stun.gd
extends EnemyState

var previous_state: String

@onready var stun_component = %StunComponent


func enter(msg := {}) -> void:
	previous_state = msg.previous_state
	
	enemy.velocity_component.stop()
	enemy.set_moving(false)
	
	stun_component.start()
	
	await get_tree().create_timer(stun_component.stun_duration).timeout
	state_machine.transition_to(previous_state)


func exit():
	stun_component.end()
