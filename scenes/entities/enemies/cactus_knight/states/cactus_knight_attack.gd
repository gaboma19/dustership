# cactus_knight_attack.gd
extends EnemyState

const ANIMATION_LENGTH: float = 1.5
const CACTUS_PROJECTILE_ARRAY_LEFT = preload(
	"res://scenes/entities/enemies/cactus_knight/cactus_projectile_array_left.tscn")
const CACTUS_PROJECTILE_ARRAY_RIGHT = preload(
	"res://scenes/entities/enemies/cactus_knight/cactus_projectile_array_right.tscn")


func enter(_msg := {}) -> void:
	var animation_state_machine = enemy.animation_state_machine as \
		AnimationNodeStateMachinePlayback
	animation_state_machine.travel("attack")
	var blend_position = direction_sign_to_player()
	enemy.update_blend_position(blend_position)
	
	await get_tree().create_timer(ANIMATION_LENGTH).timeout
	transition_to_aggro()


func direction_sign_to_player():
	var player = PartyManager.get_active_member()
	var direction: Vector2
	if player != null:
		direction = enemy.global_position.direction_to(player.global_position)
		
	return sign(direction.x)


func instantiate_projectile_array_right():
	var projectile_array = CACTUS_PROJECTILE_ARRAY_RIGHT.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(projectile_array)
	projectile_array.global_position = enemy.global_position


func instantiate_projectile_array_left():
	var projectile_array = CACTUS_PROJECTILE_ARRAY_LEFT.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(projectile_array)
	projectile_array.global_position = enemy.global_position


func transition_to_aggro():
	state_machine.transition_to("Aggro")
