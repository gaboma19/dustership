# harmonykeeper_idle.gd
extends EnemyState

@export var aggro_ray_cast: RayCast2D

@onready var attack_range_area = %AttackRangeArea


func enter(_msg := {}) -> void:
	aggro_ray_cast.player_detected.connect(on_player_detected)
	
	var player = PartyManager.get_active_member()
	if player != null:
		if aggro_ray_cast.is_player_detected:
			on_player_detected()


func update(_delta: float) -> void:
	enemy.velocity_component.stop()
	enemy.set_moving(false)
	
	enemy.update_animation_tree()


func exit():
	aggro_ray_cast.player_detected.disconnect(on_player_detected)


func on_player_detected():
	state_machine.transition_to("Aggro")
