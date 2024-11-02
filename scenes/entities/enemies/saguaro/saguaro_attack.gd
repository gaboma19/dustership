# saguaro_attack.gd
extends EnemyState

const SAGUARO_FOOT_SCENE = preload(
	"res://scenes/entities/enemies/saguaro/saguaro_foot.tscn")

@export var attack_range_area: Area2D
@export var cooldown_timer: Timer


func enter(_msg := {}) -> void:
	attack_range_area.body_exited.connect(on_attack_range_body_exited)
	
	enemy.velocity_component.stop()


func update(_delta: float):
	if cooldown_timer.is_stopped():
		cooldown_timer.start()
		attack()


func exit() -> void:
	attack_range_area.body_exited.disconnect(on_attack_range_body_exited)


func attack():
	enemy.set_attacking(true)
	enemy.velocity_component.stop()
	
	var first_target_position = get_target_position()
	spawn_foot(first_target_position)
	await get_tree().create_timer(2.6).timeout
	
	rise()
	
	await get_tree().create_timer(0.6).timeout
	reposition()


func spawn_foot(target_position: Vector2):
	var entities_layer = get_tree().get_first_node_in_group("entities")
	var saguaro_foot = SAGUARO_FOOT_SCENE.instantiate()
	entities_layer.call_deferred("add_child", saguaro_foot)
	saguaro_foot.global_position = target_position


func get_target_position() -> Vector2:
	var player: Player = PartyManager.get_active_member()
	if player == null:
		return Vector2.ZERO
	
	var target_position: Vector2
	var is_moving = player.animation_tree.get("parameters/conditions/is_moving")
	var angle = randf() * 2 * PI
	var random_vector = Vector2( sin(angle), cos(angle) )
	
	if is_moving:
		target_position = player.global_position + player.blend_position * 25
		target_position += random_vector * 7
	else:
		target_position = player.global_position
		target_position += random_vector * 5
	
	return target_position


func get_reposition_vector() -> Vector2:
	var player: Player = PartyManager.get_active_member()
	if player == null:
		return Vector2.ZERO
	
	var vector = enemy.global_position.direction_to(player.global_position)
	vector *= -50
	
	return vector


func rise():
	enemy.set_attacking(false)
	enemy.set_moving(false)
	
	enemy.animation_state_machine.travel("rise")


func reposition():
	var vector = get_reposition_vector()
	var position = enemy.global_position + vector
	enemy.set_moving(true)
	enemy.animation_tree["parameters/move/BlendSpace2D/blend_position"] = vector.normalized()
	
	enemy.velocity_component.process_accelerate_to_point(position)


func transition_to_aggro():
	var is_attacking = enemy.animation_tree.get("parameters/conditions/is_attacking")
	if is_attacking:
		rise()
	
	state_machine.transition_to("Aggro")


func on_attack_range_body_exited(_body: Node2D):
	transition_to_aggro()
