# hold.gd
extends PlayerState

@onready var pickup_area = %PickupArea
@onready var collision_shape_2d = %CollisionShape2D


func enter(_msg := {}) -> void:
	pickup_area.monitoring = false
	collision_shape_2d.disabled = true
	player.velocity_component.stop()
	player.set_moving(false)
