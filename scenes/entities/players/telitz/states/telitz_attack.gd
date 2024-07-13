# telitz_attack.gd
extends PlayerState

@export var telitz_attack_effect_scene: PackedScene
@export var hitboxes: Node2D


func enter(_msg := {}) -> void:
	PartyManager.disable_switch_character(true)
	player.set_moving(false)
	player.set_attacking(true)
	player.velocity_component.stop()
	
	await get_tree().create_timer(0.6).timeout
	transition_to_active()


func instantiate_attack_effect(direction: String):
	var attack_effect = telitz_attack_effect_scene.instantiate()
	
	var direction_node = hitboxes.get_node(direction) as Node2D
	attack_effect.global_position = direction_node.global_position
	attack_effect.global_rotation = direction_node.global_rotation
	
	match direction:
		"Up":
			attack_effect.knockback_direction = Vector2.UP
		"Down":
			attack_effect.knockback_direction = Vector2.DOWN
		"Left":
			attack_effect.knockback_direction = Vector2.LEFT
		"Right":
			attack_effect.knockback_direction = Vector2.RIGHT
	
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(attack_effect)


func transition_to_active():
	PartyManager.disable_switch_character(false)
	player.set_attacking(false)
	player.set_moving(false)
	state_machine.transition_to("Active")
