# hold.gd
extends PlayerState

@onready var pickup_area = %PickupArea
@onready var player_hurtbox_component = %PlayerHurtboxComponent


func enter(_msg := {}) -> void:
	pickup_area.set_deferred("monitorable", false)
	player_hurtbox_component.set_deferred("monitoring", false)
	player_hurtbox_component.set_deferred("monitorable", false)
	player.velocity_component.stop()
	player.set_moving(false)


func exit():
	player_hurtbox_component.set_deferred("monitoring", true)
	player_hurtbox_component.set_deferred("monitorable", true)
