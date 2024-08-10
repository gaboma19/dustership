extends Area2D

@export var tumbleweed: RigidBody2D

@onready var collision_shape_2d = $CollisionShape2D


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Node2D):
	var impulse = other_area.global_position.direction_to(
		collision_shape_2d.global_position)
	impulse *= 100
	
	tumbleweed.apply_impulse(impulse)
