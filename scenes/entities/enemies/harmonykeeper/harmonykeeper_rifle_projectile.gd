extends Line2D

@onready var hitbox_cast_component: ShapeCast2D = $HitboxCastComponent
@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)
	
	set_texture_repeat(CanvasItem.TEXTURE_REPEAT_ENABLED)
	points[1] = Vector2.ZERO
	hitbox_cast_component.target_position = Vector2.ZERO


func cast(target_position: Vector2):
	timer.start()
	var tween = create_tween()
	tween.tween_method(set_target_position, Vector2.ZERO, target_position, 1.0)


func set_target_position(value: Vector2):
	set_point_position(1, value)
	hitbox_cast_component.target_position = value


func on_timer_timeout():
	pass
