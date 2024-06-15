extends EnemyState

const KNOCKBACK_DISTANCE = 48
const KNOCKBACK_DURATION = 0.25
const KNOCKBACK_HEIGHT = 12

@export var knockback_component: KnockbackComponent
@export var sprite: Sprite2D

var wall_detector: Area2D
var previous_state: String


func enter(msg := {}) -> void:
	if msg.is_empty():
		return
	if knockback_component == null:
		return
	if sprite == null:
		return
	
	previous_state = msg.previous_state
	wall_detector = knockback_component.wall_detector
	
	if not wall_detector.area_entered.is_connected(on_wall_detected):
		wall_detector.area_entered.connect(on_wall_detected)
	
	play()


func play():
	enemy.velocity_component.stop()
	enemy.set_stunned(true)
	
	var knockback_addend = knockback_component.direction * KNOCKBACK_DISTANCE
	var final_position = enemy.global_position + knockback_addend
	var starting_offset = sprite.offset
	var final_offset = Vector2(starting_offset.x, starting_offset.y - KNOCKBACK_HEIGHT)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(enemy, "global_position", final_position, KNOCKBACK_DURATION)
	tween.tween_property(sprite, "offset", final_offset, KNOCKBACK_DURATION / 2)
	tween.chain()
	tween.tween_property(sprite, "offset", starting_offset, KNOCKBACK_DURATION / 2)
	tween.tween_callback(transition_to_previous_state)


func transition_to_previous_state():
	enemy.set_stunned(false)
	state_machine.transition_to(previous_state)


func on_wall_detected():
	print("on_wall_detected")
