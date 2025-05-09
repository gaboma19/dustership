# hold.gd
extends PlayerState

@onready var pickup_area = %PickupArea
@onready var player_hurtbox_component = %PlayerHurtboxComponent


func enter(_msg := {}) -> void:
	pickup_area.set_deferred("monitorable", false)
	player.set_hurtbox_monitoring(false)
	player.velocity_component.stop()
	player.set_moving(false)


func update(_delta: float) -> void:
	if player.velocity.is_zero_approx():
		player.set_moving(false)
	else:
		player.set_moving(true)
		player.update_blend_position(player.velocity.normalized())


func exit():
	player.set_hurtbox_monitoring(true)
