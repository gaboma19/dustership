# cube_attack.gd
extends PlayerState

const MAX_CHARGE_TIME = 3.6
const LASER_RANGE = 500

var charge_time: float
var aim_vector: Vector2

@onready var reticle_sprite = %ReticleSprite
@onready var cube_laser: RayCast2D = %CubeLaser


func enter(_msg := {}) -> void:
	player.velocity_component.stop()
	player.set_moving(false)
	player.set_attacking(true)
	
	charge_time = 0
	
	PartyManager.disable_switch_character(true)


func update(delta: float) -> void:
	if Input.is_action_pressed("attack"):
		aim_vector = get_aiming_vector()
		
		cube_laser.target_position = aim_vector * LASER_RANGE
		
		var aim_angle = aim_vector.angle()
		
		if aim_angle == 0:
			reticle_sprite.rotation = player.blend_position.angle()
			update_charge_blend_position(player.blend_position)
		else:
			reticle_sprite.rotation = aim_angle
			update_charge_blend_position(aim_vector)
		
		if reticle_sprite.visible:
			if aim_angle != 0:
				player.update_blend_position(aim_vector)
			charge_time += delta
			if charge_time <= MAX_CHARGE_TIME:
				%ChargeSprite.show()
			else:
				%ChargeSprite.hide()
	else:
		if charge_time == 0:
			transition_to_active()
		else:
			var charge_percent = charge_time / MAX_CHARGE_TIME
			fire(charge_percent)


func fire(charge_percent: float):
	cube_laser.charge_percent = charge_percent
	cube_laser.set_casting(true)
	
	await get_tree().create_timer(0.2).timeout
	reticle_sprite.hide()
	transition_to_active()


func show_reticle():
	reticle_sprite.show()


func stop_charge_animation():
	if not reticle_sprite.visible:
		%ChargeSprite.hide()


func get_aiming_vector() -> Vector2:
	var direction: Vector2
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_position = %AttackSpawn.get_local_mouse_position()
		direction = Vector2.ZERO.direction_to(mouse_position)
	else:
		direction = Input.get_vector(
			"move_left", "move_right", "move_up",  "move_down")
	
	if direction == Vector2.ZERO:
		direction = player.blend_position
	
	direction = direction.normalized()
	return direction


func update_charge_blend_position(direction: Vector2):
	player.animation_tree["parameters/Charge/blend_position"] = direction


func transition_to_active():
	player.set_attacking(false)
	player.set_moving(false)
	player.animation_state_machine.next()
	
	cube_laser.set_casting(false)
	cube_laser.target_position = Vector2.ZERO
	reticle_sprite.hide()
	
	PartyManager.disable_switch_character(false)
	
	state_machine.transition_to("Active")
