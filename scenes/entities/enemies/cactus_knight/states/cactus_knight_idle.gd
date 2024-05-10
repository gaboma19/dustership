# cactus_knight_idle.gd
extends EnemyState

var idle_length: float = 1.0


func enter(msg := {}) -> void:
	if msg.has("idle_length"):
		idle_length = msg.idle_length
	
	await get_tree().create_timer(idle_length).timeout
	transition_to_aggro()


func update(_delta: float) -> void:
	enemy.velocity_component.decelerate()
	enemy.velocity_component.move(enemy)


func transition_to_aggro():
	state_machine.transition_to("Aggro")
