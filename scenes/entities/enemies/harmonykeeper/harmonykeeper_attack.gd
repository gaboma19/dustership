# harmonykeeper_attack.gd
extends EnemyState

var aim_vector

@export var attack_range_area: Area2D
@export var attack_spawn: Node2D
@export var harmonykeeper_rifle_laser: RayCast2D


func enter(_msg := {}) -> void:
	if not attack_range_area.body_exited.is_connected(on_attack_range_body_exited):
		attack_range_area.body_exited.connect(on_attack_range_body_exited)
	
	enemy.velocity_component.stop()
	enemy.set_attacking(true)
	harmonykeeper_rifle_laser.set_casting(true)
	
	await get_tree().create_timer(1.0).timeout
	transition_to_fire()


func update(_delta: float) -> void:
	aim_vector = get_aiming_vector()
	
	harmonykeeper_rifle_laser.aim_direction = aim_vector


func get_aiming_vector():
	var player = PartyManager.get_active_member()
	var target = player.global_position
	var origin = attack_spawn.global_position
	
	# target head, not feet
	target.y -= 8
	
	return origin.direction_to(target)


func transition_to_fire():
	state_machine.transition_to("Fire")


func on_attack_range_body_exited(_body: Node2D):
	enemy.set_attacking(false)
	harmonykeeper_rifle_laser.set_casting(false)
	state_machine.transition_to("Aggro")
