extends Node2D

@export var knockback_direction: Vector2

@onready var animation_player = $AnimationPlayer
@onready var knockbox_component = $KnockboxComponent


func _ready():
	knockbox_component.knockback_direction = knockback_direction


func play():
	var parent = get_parent()
	global_position = parent.global_position
	global_rotation = parent.global_rotation
	
	animation_player.play("default")
