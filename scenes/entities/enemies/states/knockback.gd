extends EnemyState

const KNOCKBACK_DISTANCE = 48
const KNOCKBACK_DURATION = 0.25
const KNOCKBACK_HEIGHT = 12

@export var knockback_component: KnockbackComponent
@export var health_component: HealthComponent

var wall_detector: Area2D
var floor_detector: Area2D
var previous_state: String
var sprite: Sprite2D
var number_floors_crossed: int = 0


func enter(msg := {}) -> void:
	if msg.is_empty():
		return
	if knockback_component == null:
		return
	if enemy.sprite == null:
		return
	
	sprite = enemy.sprite
	previous_state = msg.previous_state
	wall_detector = knockback_component.wall_detector
	floor_detector = knockback_component.floor_detector
	
	if not wall_detector.body_entered.is_connected(on_wall_detected):
		wall_detector.body_entered.connect(on_wall_detected)
	if not floor_detector.body_entered.is_connected(on_floor_detected):
		floor_detector.body_entered.connect(on_floor_detected)
	
	launch()


func launch():
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
	tween.tween_callback(land)


func land():
	if number_floors_crossed == 1 || floor_detector.has_overlapping_bodies():
		health_component.damage(health_component.max_health)
	
	transition_to_previous_state()


func transition_to_previous_state():
	floor_detector.body_entered.disconnect(on_floor_detected)
	wall_detector.body_entered.disconnect(on_wall_detected)
	enemy.set_stunned(false)
	number_floors_crossed = 0
	state_machine.transition_to(previous_state)


func on_wall_detected(_body: Node2D):
	health_component.damage(health_component.max_health)


func on_floor_detected(_body: Node2D):
	number_floors_crossed += 1
