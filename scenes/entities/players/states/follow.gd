# follow.gd
extends PlayerState

@onready var pickup_area = %PickupArea
@onready var player_hurtbox_component = %PlayerHurtboxComponent

var active_player: Player


func enter(_msg := {}) -> void:
	pickup_area.set_deferred("monitorable", false)
	player_hurtbox_component.set_deferred("monitoring", false)
	active_player = PartyManager.get_active_member()


func exit():
	player_hurtbox_component.set_deferred("monitoring", true)


func update(_delta: float) -> void:
	if active_player == player:
		active_player = PartyManager.get_active_member()
		
	if active_player == null:
		return
	
	var distance = player.global_position.distance_to(active_player.global_position)
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
