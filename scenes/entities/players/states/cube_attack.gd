# cube_attack.gd
extends PlayerState

var charge_time: float
var is_done_charging: bool
@onready var attack_timer: Timer = %AttackTimer


func enter(_msg := {}) -> void:
	player.set_moving(false)
	player.set_attacking(true)
	player.velocity_component.stop()
	is_done_charging = false
	#attack_timer.start()
	#
	#await attack_timer.timeout
	#transition_to_active()


func update(delta: float) -> void:
	if Input.is_action_pressed("attack"):
		var aim_angle = get_aiming_vector().angle()
		%ReticleSprite.show()
		%ReticleSprite.rotation = aim_angle
		charge_time += delta
		pass
	else:
		# fire the laser and return to Active
		print(charge_time)
		%ReticleSprite.hide()
		is_done_charging = true
		transition_to_active()


func stop_charge_animation():
	if is_done_charging:
		%ChargeSprite.hide()


func get_aiming_vector():
	var direction = Input.get_vector(
		"move_left", "move_right", "move_up",  "move_down")
	
	return direction


func transition_to_active():
	player.set_attacking(false)
	state_machine.transition_to("Active")
