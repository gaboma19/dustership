# harmonykeeper_aggro.gd
extends EnemyState

@export var aggro_ray_cast: RayCast2D

var floating_text_scene = preload("res://scenes/ui/floating_text/floating_text.tscn")

@onready var attack_range_area = %AttackRangeArea


func enter(_msg := {}) -> void:
	if not attack_range_area.body_entered.is_connected(on_attack_range_body_entered):
		attack_range_area.body_entered.connect(on_attack_range_body_entered)


func update(_delta: float) -> void:
	enemy.velocity_component.accelerate_to_player()
	enemy.velocity_component.move(enemy)
	
	enemy.update_animation_tree()


func on_body_exited(_body: Node2D):
	state_machine.transition_to("Chase")


func on_attack_range_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	state_machine.transition_to("Attack")
