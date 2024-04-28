# hold.gd
extends PlayerState

@onready var pickup_area = %PickupArea
@onready var collision_shape_2d = %CollisionShape2D
@onready var player_hurtbox_component = %PlayerHurtboxComponent


func enter(_msg := {}) -> void:
	pickup_area.monitoring = false
	collision_shape_2d.set_deferred("disabled", true)
	player_hurtbox_component.set_deferred("monitoring", false)
	player.velocity_component.stop()
	player.set_moving(false)


func exit():
	player_hurtbox_component.set_deferred("monitoring", true)
