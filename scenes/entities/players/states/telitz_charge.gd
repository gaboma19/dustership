# telitz_charge.gd
extends PlayerState

const MAX_CHARGE_TIME = 1.2

var charge_time: float


func enter(_msg := {}) -> void:
	charge_time = 0
	
	player.velocity_component.stop()
	player.set_moving(false)
	
	set_charging(true)
	
	PartyManager.disable_switch_character(true)


func update(delta: float) -> void:
	if Input.is_action_pressed("special"):
		charge_time += delta
		
		if charge_time >= MAX_CHARGE_TIME:
			transition_to_float()
	else:
		if charge_time < MAX_CHARGE_TIME:
			transition_to_active()
		else:
			transition_to_float()


func set_charging(value: bool):
	var charge_direction = player.blend_position.normalized()
	player.animation_tree["parameters/Charge/blend_position"] = charge_direction
	
	player.animation_tree.set("parameters/conditions/is_idle", not value)
	player.animation_tree.set("parameters/conditions/is_moving", not value)
	player.animation_tree.set("parameters/conditions/is_charging", value)


func transition_to_active():
	PartyManager.disable_switch_character(false)
	state_machine.transition_to("Active")


func transition_to_float():
	state_machine.transition_to("Float")
