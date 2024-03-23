extends Node2D

@onready var animation_tree = $AnimationTree


func update_blend_position(direction: Vector2):
	animation_tree["parameters/blend_position"] = direction
