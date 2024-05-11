extends Area2D

@export var collision_shape: Node2D


func modify_circle_shape_radius(value: int):
	if "shape" in collision_shape:
		if collision_shape.shape is CircleShape2D:
			collision_shape.shape.radius += value
