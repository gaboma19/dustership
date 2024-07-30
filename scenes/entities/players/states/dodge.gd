# dodge.gd
extends PlayerState

const DODGE_TIME: float = 0.6
const DODGE_DISTANCE: int = 48

var dodge_direction: Vector2
var dodge_point: Vector2
var original_speed: int
var original_acceleration: float
var velocity_component: VelocityComponent
var animation_tree: AnimationTree


func enter(_msg := {}) -> void:
	PartyManager.disable_switch_character(true)
	player.player_hurtbox_component.set_deferred("monitoring", false)
	player.player_hurtbox_component.set_deferred("monitorable", false)
	
	velocity_component = player.velocity_component
	animation_tree = player.animation_tree
	dodge_direction = player.blend_position.normalized()
	dodge_point = player.global_position + (dodge_direction * DODGE_DISTANCE)
	
	set_dodging(true)
	
	original_speed = velocity_component.max_speed
	original_acceleration = velocity_component.acceleration
	velocity_component.max_speed = int(original_speed * 2)
	
	var tween = create_tween()
	tween.tween_property(velocity_component, "max_speed", original_speed, DODGE_TIME) \
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(transition_to_active)


func update(_delta: float) -> void:
	var distance = player.global_position.distance_to(dodge_point)
	
	if distance > 1:
		velocity_component.accelerate_to_point(dodge_point)
		velocity_component.move(player)


func exit():
	PartyManager.disable_switch_character(false)
	player.player_hurtbox_component.set_deferred("monitoring", true)
	player.player_hurtbox_component.set_deferred("monitorable", true)
	set_dodging(false)


func set_dodging(value: bool):
	animation_tree["parameters/Dodge/blend_position"] = dodge_direction
	
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", not value)
	animation_tree.set("parameters/conditions/is_dodging", value)


func transition_to_active():
	state_machine.transition_to("Active")
