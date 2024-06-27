# spawn.gd
extends EnemyState

const SPAWN_TIME = 1.6
const TRANSITION_DELAY = 0.6

@export var spawn_audio_stream_player: AudioStreamPlayer2D

@onready var spawn_material: ShaderMaterial = preload(
	"res://resources/materials/spawn_material.tres")
@onready var sprite = %Sprite2D
@onready var hurtbox_component = %HurtboxComponent


func enter(_msg := {}) -> void:
	sprite.material = spawn_material
	(sprite.material as ShaderMaterial).set_shader_parameter(
		"dissolve_texture", sprite.texture)
	# inconsistent behavior when using "shader_parameter/parameter_name" or "parameter_name" as the argument to set_shader_parameter(). ref: https://www.reddit.com/r/godot/comments/17eanmn/why_cant_i_set_a_shader_parameter_in_code_godot_4/
	
	spawn()


func spawn():
	sprite.scale = Vector2(3, 3)
	hurtbox_component.monitoring = false
	
	if spawn_audio_stream_player != null:
		spawn_audio_stream_player.play_random()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite.material, "shader_parameter/dissolve_value", 0.5, 0)
	tween.chain()
	tween.tween_property(sprite.material, "shader_parameter/dissolve_value", 1.0, SPAWN_TIME)
	tween.tween_property(sprite, "scale", Vector2.ONE, SPAWN_TIME)
	tween.chain()
	tween.tween_callback(on_tween_callback)


func on_tween_callback():
	if enemy.has_node("HitFlashComponent"):
		var hit_flash_component = enemy.get_node("HitFlashComponent")
		hit_flash_component.set_sprite_material()
	hurtbox_component.monitoring = true
	
	if spawn_audio_stream_player != null:
		spawn_audio_stream_player.stop()
	
	await get_tree().create_timer(TRANSITION_DELAY).timeout
	
	state_machine.transition_to("Idle")
