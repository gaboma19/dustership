# harmonykeeper_attack.gd
extends EnemyState

var aim_vector
var is_tracking_player: bool

@export var attack_range_area: Area2D
@export var attack_spawn: Node2D
@export var harmonykeeper_rifle_laser: RayCast2D
@export var aim_timer: Timer


func enter(_msg := {}) -> void:
	attack_range_area.body_exited.connect(on_attack_range_body_exited)
	aim_timer.timeout.connect(on_aim_timer_timeout)
	
	enemy.velocity_component.stop()
	enemy.set_attacking(true)
	
	cast_laser()


func update(_delta: float) -> void:
	if is_tracking_player:
		var direction = get_direction_to_target()
		if direction != null:
			enemy.update_blend_position(direction)
		
		aim_vector = get_aiming_vector()
		
		harmonykeeper_rifle_laser.aim_direction = aim_vector


func exit() -> void:
	attack_range_area.body_exited.disconnect(on_attack_range_body_exited)
	aim_timer.timeout.disconnect(on_aim_timer_timeout)
	
	harmonykeeper_rifle_laser.hide_laser()


func cast_laser():
	harmonykeeper_rifle_laser.set_casting(true)
	harmonykeeper_rifle_laser.appear()
	
	is_tracking_player = true
	
	aim_timer.start()


func get_aiming_vector():
	var player = PartyManager.get_active_member()
	var target = player.global_position
	var origin = attack_spawn.global_position
	
	# target head, not feet
	target.y -= 8
	
	return origin.direction_to(target)


func get_direction_to_target():
	var player = PartyManager.get_active_member()
	if player == null:
		return
	
	var target = player.global_position
	
	return enemy.global_position.direction_to(target)


func check_collider():
	var collider = harmonykeeper_rifle_laser.get_collider()
	
	if collider is PlayerHurtboxComponent:
		is_tracking_player = false
		
		harmonykeeper_rifle_laser.disappear()
		await get_tree().create_timer(0.75).timeout
		
		harmonykeeper_rifle_laser.set_casting(false)
		transition_to_fire()
	else:
		aim_timer.start()


func transition_to_fire():
	state_machine.transition_to("Fire")


func on_attack_range_body_exited(_body: Node2D):
	enemy.set_attacking(false)
	harmonykeeper_rifle_laser.set_casting(false)
	harmonykeeper_rifle_laser.hide_laser()
	state_machine.transition_to("Aggro")


func on_aim_timer_timeout():
	check_collider()
