# follow.gd
extends PlayerState

@onready var pickup_area = %PickupArea
@onready var player_hurtbox_component = %PlayerHurtboxComponent

var follow_target: Player


func enter(_msg := {}) -> void:
	pickup_area.set_deferred("monitorable", false)
	
	if player != null:
		player.set_hurtbox_monitoring(false)


func exit():
	if player != null:
		player.set_hurtbox_monitoring(true)


func update(_delta: float) -> void:
	follow_target = PartyManager.get_follow_target(player)
		
	if follow_target == null:
		return
	
	var distance = player.global_position.distance_to(follow_target.global_position)
	if distance > 16:
		player.velocity_component.accelerate_to_player()
		player.velocity_component.move(player)
	else:
		player.velocity_component.stop()
	
	if player.velocity.is_zero_approx():
		player.set_moving(false)
	else:
		player.set_moving(true)
		player.update_blend_position(player.velocity.normalized())
