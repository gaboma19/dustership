# telitz_attack.gd
extends PlayerState

const TELITZ_ATTACK_EFFECT_SCENE = preload("res://scenes/entities/telitz_denz/telitz_attack_effect.tscn")

@export var hitboxes: Node2D


func enter(_msg := {}) -> void:
	PartyManager.disable_switch_character(true)
	player.set_moving(false)
	player.set_attacking(true)
	player.velocity_component.stop()
	
	await get_tree().create_timer(0.6).timeout
	transition_to_active()


func instantiate_attack_effect(direction: String):
	var attack_effect = TELITZ_ATTACK_EFFECT_SCENE.instantiate()
	
	hitboxes.get_node(direction).add_child(attack_effect)
	attack_effect.play()


func transition_to_active():
	PartyManager.disable_switch_character(false)
	player.set_attacking(false)
	player.set_moving(false)
	state_machine.transition_to("Active")
