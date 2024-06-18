extends Node2D

var knockback_direction: Vector2

@onready var animation_player = $AnimationPlayer
@onready var knockbox_component = $KnockboxComponent


func _ready():
	knockbox_component.knockback_direction = knockback_direction
