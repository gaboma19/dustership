# npcs/dusteki/idle.gd
extends State

@onready var dusteki = owner as Npc
@export var idle_timer: Timer


func enter(_msg := {}) -> void:
	dusteki.velocity_component.stop()
	
	#play_idle_animation()


#func exit() -> void:
	#stop_idle_animation()


func stop_idle_animation():
	if idle_timer == null:
		return
	
	idle_timer.stop()
	idle_timer.timeout.disconnect(on_idle_timer_timeout)


func play_idle_animation():
	if idle_timer == null:
		return
	
	var delay = randf_range(0.0, 0.4)
	idle_timer.wait_time += delay
	
	idle_timer.timeout.connect(on_idle_timer_timeout)
	idle_timer.start()


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
	
	velocity_component.process_accelerate_to_point(point)
	
	await get_tree().create_timer(2.0).timeout
	velocity_component.stop()
