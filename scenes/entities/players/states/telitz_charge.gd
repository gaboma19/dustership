# telitz_charge.gd
extends PlayerState

const MAX_CHARGE_TIME = 1.2

var charge_time: float
var charge_tween: Tween


func enter(_msg := {}) -> void:
	charge_time = 0
	
	player.velocity_component.stop()
	player.set_moving(false)
	
	set_charging(true)
	
	PartyManager.disable_switch_character(true)


func update(delta: float) -> void:
	if Input.is_action_pressed("special"):
		charge_time += delta
		
		if charge_time > 0.6:
			animate_sprite()
		
		if charge_time >= MAX_CHARGE_TIME:
			transition_to_float()
	else:
		if charge_time < MAX_CHARGE_TIME:
			transition_to_active()
		else:
			transition_to_float()


func exit() -> void:
	(player.sprite.material as ShaderMaterial).set_shader_parameter(
		"noise_amount", 0)
	
	if charge_tween != null:
		charge_tween.kill()


func set_charging(value: bool):
	var charge_direction = player.blend_position.normalized()
	player.animation_tree["parameters/Charge/blend_position"] = charge_direction
	
	player.animation_tree.set("parameters/conditions/is_idle", not value)
	player.animation_tree.set("parameters/conditions/is_moving", not value)
	player.animation_tree.set("parameters/conditions/is_charging", value)


func animate_sprite():
	if charge_tween != null && charge_tween.is_valid():
		return
	
	var sprite = player.sprite
	charge_tween = create_tween()
	charge_tween.tween_property(sprite.material, "shader_parameter/noise_amount", 1.0, 0.6)


func transition_to_active():
	PartyManager.disable_switch_character(false)
	
	set_charging(false)
	
	state_machine.transition_to("Active")


func transition_to_float():
	state_machine.transition_to("Float")
