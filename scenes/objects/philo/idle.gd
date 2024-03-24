extends EnemyState

@onready var aggro_area_2d = %AggroArea2D


func enter(_msg := {}) -> void:
	if not aggro_area_2d.body_entered.is_connected(on_body_entered):
		aggro_area_2d.body_entered.connect(on_body_entered)


func update(_delta: float) -> void:
	enemy.velocity_component.decelerate()
	enemy.velocity_component.move(enemy)


func on_body_entered(_body: Node2D):
	state_machine.transition_to("Aggro")
