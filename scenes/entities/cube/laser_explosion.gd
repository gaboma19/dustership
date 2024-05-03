extends Node2D

var damage: int = 5
var stun_duration: float = 4.0


func _ready():
	$HitboxComponent.damage = damage
	$StunboxComponent.stun_duration = stun_duration

	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.0888) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	tween.tween_callback(queue_free)
