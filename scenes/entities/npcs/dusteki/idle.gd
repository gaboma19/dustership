# npcs/dusteki/idle.gd
extends State

@onready var dusteki = owner as Npc
@export var idle_timer: Timer


func enter(_msg := {}) -> void:
	dusteki.velocity_component.stop()
	
	var delay = randf_range(0.0, 0.4)
	idle_timer.wait_time += delay
	
	idle_timer.timeout.connect(on_idle_timer_timeout)
	idle_timer.start()


func exit() -> void:
	idle_timer.stop()
	idle_timer.timeout.disconnect(on_idle_timer_timeout)


func get_random_cardinal_vector2() -> Vector2:
	var directions = [
		Vector2.RIGHT, 
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN
	]
	return directions[randi() % directions.size()]


func on_idle_timer_timeout():
	var direction = get_random_cardinal_vector2()
	var point = dusteki.global_position + (direction * 16)
	var velocity_component: VelocityComponent = dusteki.velocity_component
	
	velocity_component.accelerate_to_point_and_stop(point)
