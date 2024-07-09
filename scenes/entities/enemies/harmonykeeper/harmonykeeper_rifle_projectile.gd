extends Line2D

@onready var hitbox_cast_component: ShapeCast2D = $HitboxCastComponent
@onready var timer = $Timer
@onready var floor_detector_ray_cast = $FloorDetectorRayCast
@onready var animation_player = $AnimationPlayer


func _ready():
	timer.timeout.connect(on_timer_timeout)
	
	set_texture_repeat(CanvasItem.TEXTURE_REPEAT_ENABLED)
	points[1] = Vector2.ZERO
	hitbox_cast_component.target_position = Vector2.ZERO


func cast(target_position: Vector2):
	timer.start()
	
	# give the floor detector the same target position as the laser
	floor_detector_ray_cast.target_position = target_position
	floor_detector_ray_cast.force_raycast_update()
	if floor_detector_ray_cast.is_colliding():
		target_position = to_local(floor_detector_ray_cast.get_collision_point())
	
	var tween = create_tween()
	tween.tween_method(set_target_position, Vector2.ZERO, target_position, 0.2)


func set_target_position(value: Vector2):
	set_point_position(1, value)
	hitbox_cast_component.target_position = value


func on_timer_timeout():
	animation_player.play("dissolve")
	await get_tree().create_timer(1.0).timeout
	queue_free()
