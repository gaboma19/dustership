# harmonykeeper_idle.gd
extends EnemyState

@export var aggro_ray_cast: RayCast2D

@onready var attack_range_area = %AttackRangeArea


func enter(_msg := {}) -> void:
	aggro_ray_cast.player_detected.connect(on_player_detected)
	attack_range_area.body_entered.connect(on_attack_range_body_entered)
	
	var player = PartyManager.get_active_member()
	if player != null:
		if aggro_ray_cast.is_player_detected:
			on_player_detected()
		if attack_range_area.overlaps_body(player):
			on_attack_range_body_entered(player)


func update(_delta: float) -> void:
	enemy.velocity_component.stop()
	enemy.set_moving(false)
	
	enemy.update_animation_tree()


func exit():
	aggro_ray_cast.player_detected.disconnect(on_player_detected)
	
	if attack_range_area.body_entered.is_connected(on_attack_range_body_entered):
		attack_range_area.body_entered.disconnect(on_attack_range_body_entered)


func on_player_detected():
	state_machine.transition_to("Aggro")


func on_attack_range_body_entered(_body: Node2D):
	pass
	#state_machine.transition_to("Attack")
