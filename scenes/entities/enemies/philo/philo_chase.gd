# philo_chase.gd
extends EnemyState

var target_point: Vector2

@onready var aggro_area = %AggroArea


func enter(_msg := {}) -> void:
	aggro_area.body_entered.connect(on_aggro_body_entered)
	
	enemy.velocity_component.max_speed *= 4
	enemy.velocity_component.acceleration *= 4
	
	var player = PartyManager.get_active_member()
	target_point = player.global_position
	
	enemy.animation_state_machine.travel("morph")


func update(_delta: float) -> void:
	var distance = enemy.global_position.distance_to(target_point)
	
	if distance > 1:
		enemy.velocity_component.accelerate_to_point(target_point)
		enemy.velocity_component.move(enemy)
	else:
		enemy.animation_state_machine.travel("unmorph")
		state_machine.transition_to("Idle")


func exit():
	enemy.velocity_component.max_speed /= 4
	enemy.velocity_component.acceleration /= 4
	
	if aggro_area.body_entered.is_connected(on_aggro_body_entered):
		aggro_area.body_entered.disconnect(on_aggro_body_entered)


func on_aggro_body_entered(_body: Node2D):
	enemy.animation_state_machine.travel("unmorph")
	state_machine.transition_to("Aggro")
