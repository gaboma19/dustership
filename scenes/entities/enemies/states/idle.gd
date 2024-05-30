# idle.gd
extends EnemyState

@onready var aggro_area = %AggroArea
@onready var attack_range_area = %AttackRangeArea


func enter(_msg := {}) -> void:
	aggro_area.body_entered.connect(on_aggro_body_entered)
	attack_range_area.body_entered.connect(on_attack_range_body_entered)
	
	var player = PartyManager.get_active_member()
	if player != null:
		if aggro_area.overlaps_body(player):
			on_aggro_body_entered(player)
		if attack_range_area.overlaps_body(player):
			on_attack_range_body_entered(player)


func update(_delta: float) -> void:
	enemy.velocity_component.decelerate()
	enemy.velocity_component.move(enemy)


func exit():
	if aggro_area.body_entered.is_connected(on_aggro_body_entered):
		aggro_area.body_entered.disconnect(on_aggro_body_entered)
	if attack_range_area.body_entered.is_connected(on_attack_range_body_entered):
		attack_range_area.body_entered.disconnect(on_attack_range_body_entered)


func on_aggro_body_entered(_body: Node2D):
	state_machine.transition_to("Aggro")


func on_attack_range_body_entered(_body: Node2D):
	state_machine.transition_to("Attack")
