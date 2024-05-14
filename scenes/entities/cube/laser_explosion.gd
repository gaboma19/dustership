extends Node2D

@export var min_radius: int = 16
@export var max_radius: int = 32
@export var min_stun_duration: int = 4
@export var max_stun_duration: int = 8

var damage: int = 1
var charge_percent: float

@onready var hitbox_collision_shape = $HitboxComponent/HitboxCollisionShape
@onready var stunbox_collision_shape = $StunboxComponent/StunboxCollisionShape
@onready var audio_stream_player = $RandomAudioStreamPlayer2D


func _ready():
	audio_stream_player.play_random()
	
	var radius = min_radius + ((max_radius - min_radius) * charge_percent)
	var stun_duration = min_stun_duration + (
		(max_stun_duration - min_stun_duration) * charge_percent)
		
	hitbox_collision_shape.shape.radius = radius
	stunbox_collision_shape.shape.radius = radius
	$HitboxComponent.damage = damage
	$StunboxComponent.stun_duration = stun_duration
	
	var scale_factor = 1 + charge_percent
	var max_scale = Vector2(scale_factor, scale_factor)

	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0)
	tween.tween_property($Sprite2D, "scale", max_scale, 0.0888) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	tween.tween_callback(queue_free)
