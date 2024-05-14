extends RayCast2D

const LASER_EXPLOSION_SCENE = preload("res://scenes/entities/cube/laser_explosion.tscn")
var can_explode: bool = true
var charge_percent: float = 0

@onready var line_2d = $Line2D
@onready var audio_stream_player = $RandomAudioStreamPlayer2D


func _ready():
	line_2d.set_texture_repeat(CanvasItem.TEXTURE_REPEAT_ENABLED)
	line_2d.points[1] = Vector2.ZERO
	target_position = Vector2.ZERO
	
	set_physics_process(false)


func _physics_process(_delta):
	var cast_point = target_position
	
	$CollisionParticles.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		$CollisionParticles.global_rotation = get_collision_normal().angle()
		$CollisionParticles.position = cast_point
		
		var object = get_collider()
		if object is Enemy and can_explode:
			can_explode = false
			var laser_explosion = LASER_EXPLOSION_SCENE.instantiate()
			laser_explosion.charge_percent = charge_percent
			add_child(laser_explosion)
			laser_explosion.position = cast_point
		elif object is BatteryChargeArea:
			var battery: Battery = object.get_parent()
			battery.turn_on()
	
	$BeamParticles.position = cast_point * 0.5
	$BeamParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	line_2d.points[1] = cast_point


func set_casting(value: bool):
	$BeamParticles.emitting = value
	$CastParticles.emitting = value
	set_physics_process(value)
	
	await get_tree().process_frame
	if value:
		appear()
	else:
		$CollisionParticles.emitting = false
		can_explode = true
		disappear()


func appear():
	audio_stream_player.play_random()
	
	var tween = create_tween()
	var max_width = 5
	if charge_percent >= 1:
		max_width = 10
	tween.tween_property(line_2d, "width", max_width, 0.2)


func disappear():
	var tween = create_tween()
	tween.tween_property(line_2d, "width", 0, 0.1)
