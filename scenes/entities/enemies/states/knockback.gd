extends EnemyState

const KNOCKBACK_DISTANCE = 48
const KNOCKBACK_DURATION = 0.25

@export var knockback_component: KnockbackComponent

var previous_state: String


func enter(msg := {}) -> void:
	if msg.is_empty():
		return
	if knockback_component == null:
		return
	
	previous_state = msg.previous_state
	
	enemy.velocity_component.stop()
	enemy.set_stunned(true)
	
	var knockback_addend = knockback_component.direction * KNOCKBACK_DISTANCE
	var final_position = enemy.global_position + knockback_addend
	
	var tween = create_tween()
	tween.tween_property(enemy, "global_position", final_position, KNOCKBACK_DURATION)
	tween.tween_callback(transition_to_previous_state)


func transition_to_previous_state():
	enemy.set_stunned(false)
	state_machine.transition_to(previous_state)
