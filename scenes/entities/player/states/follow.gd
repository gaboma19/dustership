# follow.gd
extends PlayerState

var active_player: Player


func enter(_msg := {}) -> void:
	active_player = PartyManager.get_active_member()


func update(_delta: float) -> void:
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