# idle.gd
extends EnemyState

@export var aggro_area: Area2D
@export var attack_range_area: Area2D

var floating_text_scene = preload("res://scenes/ui/floating_text/floating_text.tscn")


func enter(_msg := {}) -> void:
	aggro_area.body_entered.connect(on_aggro_body_entered)
	attack_range_area.body_entered.connect(on_attack_range_body_entered)


func update(_delta: float) -> void:
	enemy.velocity_component.decelerate()
	enemy.velocity_component.move(enemy)


func exit():
	aggro_area.body_entered.disconnect(on_aggro_body_entered)
	attack_range_area.body_entered.disconnect(on_attack_range_body_entered)


func floating_text_start(text: String):
	if is_inside_tree():
		var floating_text = floating_text_scene.instantiate() as Node2D
		var foreground_layer = get_tree().get_first_node_in_group("foreground")
		if foreground_layer != null:
			foreground_layer.add_child(floating_text)
		floating_text.global_position = enemy.global_position + (Vector2.UP * 16)
		floating_text.start(text)


func on_aggro_body_entered(_body: Node2D):
	floating_text_start("!")
	
	state_machine.transition_to("Aggro")
	
	
func on_attack_range_body_entered(_body: Node2D):
	state_machine.transition_to("Attack")
