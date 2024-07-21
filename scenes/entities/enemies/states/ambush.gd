# ambush.gd
extends EnemyState

@export var ambush_range_area: Area2D


func enter(_msg := {}) -> void:
	enemy.hide()
	ambush_range_area.body_entered.connect(on_body_entered)


func exit() -> void:
	if enemy != null:
		enemy.show()
	ambush_range_area.body_entered.disconnect(on_body_entered)


func on_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	state_machine.transition_to("Spawn")
