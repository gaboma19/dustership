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
	
	var first_target_position = get_target_position()
	spawn_foot(first_target_position)
	await get_tree().create_timer(0.4).timeout
	
	var second_target_position = get_target_position()
	if not first_target_position == second_target_position:
		spawn_foot(second_target_position)
	await get_tree().create_timer(2.2).timeout
	
	rise()


func spawn_foot(target_position: Vector2):
	var entities_layer = get_tree().get_first_node_in_group("entities")
	var saguaro_foot = SAGUARO_FOOT_SCENE.instantiate()
	entities_layer.call_deferred("add_child", saguaro_foot)
	saguaro_foot.global_position = target_position


func get_target_position():
	var player = PartyManager.get_active_member()
	if player == null:
		return Vector2.ZERO
	
	return player.global_position


func rise():
	enemy.set_attacking(false)
	enemy.animation_state_machine.travel("rise")


func transition_to_aggro():
	var is_attacking = enemy.animation_tree.get("parameters/conditions/is_attacking")
	if is_attacking:
		rise()
	
	state_machine.transition_to("Aggro")


func on_attack_range_body_exited(_body: Node2D):
	transition_to_aggro()
