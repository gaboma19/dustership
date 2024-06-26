# cactus_knight_shoot.gd
extends EnemyState

const ANIMATION_LENGTH: float = 3.9
const CACTUS_PROJECTILE_ARRAY_CIRCLE = preload(
	"res://scenes/entities/enemies/cactus_knight/cactus_projectile_array_circle.tscn")
const CACTUS_PROJECTILE_ARRAY_CIRCLE_2 = preload(
	"res://scenes/entities/enemies/cactus_knight/cactus_projectile_array_circle_2.tscn")
var boss_platform: Node2D
var animation_state_machine: AnimationNodeStateMachinePlayback
var is_shooting: bool = false


func enter(_msg := {}) -> void:
	enemy.velocity_component.max_speed *= 4
	enemy.velocity_component.acceleration *= 4
	
	animation_state_machine = enemy.animation_state_machine
	
	var events = get_tree().get_first_node_in_group("events")
	boss_platform = events.get_node("BossPlatform")


func update(_float) -> void:
	var distance = enemy.global_position.distance_to(
		boss_platform.global_position)
	if distance > 1:
		enemy.velocity_component.accelerate_to_point(
			boss_platform.global_position)
		enemy.velocity_component.move(enemy)
	else:
		enemy.velocity_component.decelerate()
		enemy.velocity_component.move(enemy)
		
		shoot()


func exit():
	enemy.velocity_component.max_speed /= 4
	enemy.velocity_component.acceleration /= 4
	is_shooting = false


func shoot():
	if is_shooting:
		return
	is_shooting = true
	
	animation_state_machine.travel("attack_360")
	
	await get_tree().create_timer(ANIMATION_LENGTH * 3).timeout

	state_machine.transition_to("Aggro")


func instantiate_projectile_array():
	var projectile_array = CACTUS_PROJECTILE_ARRAY_CIRCLE.instantiate()
	var projectile_array_2 = CACTUS_PROJECTILE_ARRAY_CIRCLE_2.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	
	entities_layer.add_child(projectile_array)
	projectile_array.global_position = enemy.global_position
	
	await get_tree().create_timer(0.2).timeout
	entities_layer.add_child(projectile_array_2)
	projectile_array_2.global_position = enemy.global_position
