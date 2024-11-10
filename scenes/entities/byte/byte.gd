extends Node2D

const NUMBER_FRAMES: int = 8

@export var byte_value: int = 1

@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollectionArea/CollisionShape2D


func _ready():
	hide()
	$CollectionArea.area_entered.connect(on_collection_area_entered)
	
	var delay: float = randf()
	await get_tree().create_timer(delay).timeout
	
	show()
	tween_bounce()
	sprite.frame = randi_range(0, NUMBER_FRAMES - 1)


func tween_bounce():
	var angle: float = randf() * 2.0 * PI
	var direction: Vector2 = Vector2(cos(angle), sin(angle))
	var distance: float = 32 + randf_range(-16, 16)
	var final_val: Vector2 = distance * direction

	var tween = create_tween()
	tween.tween_property(self, "position", final_val, 0.8).as_relative()


func tween_collect(percent: float, start_position: Vector2):
	var player = PartyManager.get_active_member()
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collect():
	GameEvents.emit_bytes_gained(byte_value)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true


func play_audio_delayed():
	await get_tree().create_timer(0.4).timeout
	%BytePickupAudio.play_random()


func on_collection_area_entered(_area: Area2D):
	Callable(disable_collision).call_deferred()
	play_audio_delayed()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(collect)
