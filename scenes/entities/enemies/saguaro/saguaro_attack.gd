# saguaro_attack.gd
extends EnemyState

const SAGUARO_FOOT_SCENE = preload(
	"res://scenes/entities/enemies/saguaro/saguaro_foot.tscn")

@export var attack_range_area: Area2D


func enter(_msg := {}) -> void:
	attack_range_area.body_exited.connect(on_attack_range_body_exited)
	
	enemy.velocity_component.stop()

	enemy.set_attacking(true)
	spawn_foot()


func exit() -> void:
	attack_range_area.body_exited.disconnect(on_attack_range_body_exited)


func spawn_foot():
	var entities_layer = get_tree().get_first_node_in_group("entities")
	var saguaro_foot = SAGUARO_FOOT_SCENE.instantiate()
	entities_layer.call_deferred("add_child", saguaro_foot)
	saguaro_foot.global_position = get_target_position()


func get_target_position():
	var player = PartyManager.get_active_member()
	if player == null:
		return Vector2.ZERO
	
	return player.global_position


func transition_to_aggro():
	enemy.set_attacking(false)
	state_machine.transition_to("Aggro")


func transition_to_idle():
	enemy.set_attacking(false)
	state_machine.transition_to("Idle")


func on_attack_range_body_exited(_body: Node2D):
	transition_to_aggro()
