# harmonykeeper_aggro.gd
extends EnemyState

@export var aggro_ray_cast: RayCast2D

@onready var attack_range_area = %AttackRangeArea


func enter(_msg := {}) -> void:
	attack_range_area.body_entered.connect(on_attack_range_body_entered)
	aggro_ray_cast.player_lost.connect(on_player_lost)
	
	var player = PartyManager.get_active_member()
	if player != null:
		if attack_range_area.overlaps_body(player):
			on_attack_range_body_entered(player)
	
	enemy.set_attacking(false)


func exit() -> void:
	aggro_ray_cast.player_lost.disconnect(on_player_lost)
	attack_range_area.body_entered.disconnect(on_attack_range_body_entered)


func update(_delta: float) -> void:
	enemy.velocity_component.accelerate_to_player()
	enemy.velocity_component.move(enemy)
	
	enemy.update_animation_tree()


func on_body_exited(_body: Node2D):
	state_machine.transition_to("Idle")


func on_attack_range_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	state_machine.transition_to("Attack")


func on_player_lost():
	state_machine.transition_to("Idle")
