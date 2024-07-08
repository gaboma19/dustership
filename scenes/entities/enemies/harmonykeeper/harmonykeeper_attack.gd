# harmonykeeper_attack.gd
extends EnemyState

var aim_vector

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
	aim_vector = get_aiming_vector()
	
	harmonykeeper_rifle_laser.aim_direction = aim_vector


func exit() -> void:
	attack_range_area.body_exited.disconnect(on_attack_range_body_exited)
	aim_timer.timeout.disconnect(on_aim_timer_timeout)


func cast_laser():
	harmonykeeper_rifle_laser.set_casting(true)
	
	aim_timer.start()


func get_aiming_vector():
	var player = PartyManager.get_active_member()
	var target = player.global_position
	var origin = attack_spawn.global_position
	
	# target head, not feet
	target.y -= 8
	
	return origin.direction_to(target)


func check_collider():
	var collider = harmonykeeper_rifle_laser.get_collider()
	
	if collider is PlayerHurtboxComponent:
		transition_to_fire()
	else:
		aim_timer.start()


func transition_to_fire():
	state_machine.transition_to("Fire")


func on_attack_range_body_exited(_body: Node2D):
	enemy.set_attacking(false)
	harmonykeeper_rifle_laser.set_casting(false)
	state_machine.transition_to("Aggro")


func on_aim_timer_timeout():
	check_collider()
