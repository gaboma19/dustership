# telitz_denz_spawn.gd
extends State

var sprite: Sprite2D

@onready var telitz_denz = owner as Npc


func enter(_msg := {}) -> void:
	sprite = telitz_denz.sprite
	
	var april = PartyManager.get_april()
	april.state_machine.transition_to("Hold")
	
	spawn()


func spawn():
	sprite.scale = Vector2(3, 3)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite.material, "shader_parameter/alpha", 0, 0)
	tween.tween_property(sprite.material, "shader_parameter/effect_factor", 1, 0)
	tween.tween_property(sprite.material, "shader_parameter/noise_amount", 1, 0)
	tween.chain()
	tween.tween_property(sprite.material, "shader_parameter/alpha", 1, 1.6)
	tween.tween_property(sprite.material, "shader_parameter/effect_factor", 0.1, 1.6)
	tween.tween_property(sprite.material, "shader_parameter/noise_amount", 0.1, 1.6)
	tween.tween_property(sprite, "scale", Vector2.ONE, 1.6)
	tween.chain()
	tween.tween_callback(on_tween_callback)


func on_tween_callback():
	state_machine.transition_to("Scene")
