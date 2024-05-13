# dodge.gd
extends PlayerState

const DODGE_TIME: float = 0.6
const DODGE_DISTANCE: int = 16

var dodge_direction: Vector2
var dodge_point: Vector2

@onready var velocity_component: VelocityComponent = player.velocity_component
@onready var animation_tree: AnimationTree = player.animation_tree


func enter(_msg := {}) -> void:
	PartyManager.disable_switch_character(true)
	set_dodging(true)
	
	dodge_direction = player.blend_position
	dodge_point = player.global_position + (dodge_direction * DODGE_DISTANCE)
	
	velocity_component.max_speed *= 4
	velocity_component.acceleration *= 4
	
	await get_tree().create_timer(DODGE_TIME).timeout
	state_machine.transition_to("Active")


func update(_delta: float) -> void:
	var distance = player.global_position.distance_to(dodge_point)
	
	if distance > 1:
		velocity_component.accelerate_to_point(dodge_point)
		velocity_component.move(player)
	else:
		velocity_component.decelerate()
		velocity_component.move(player)


func exit():
	PartyManager.disable_switch_character(false)
	set_dodging(false)
	velocity_component.max_speed /= 4
	velocity_component.acceleration /= 4


func set_dodging(value: bool):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", not value)
	animation_tree.set("parameters/conditions/is_dodging", value)
