extends Node2D

var damage: int = 5


func _ready():
	$HitboxComponent.damage = damage

	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.0888) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	tween.tween_callback(queue_free)