# active.gd
extends PlayerState

@onready var pickup_area = %PickupArea

var movement_vector: Vector2 = Vector2.ZERO


func enter(_msg := {}) -> void:
	pickup_area.monitoring = true


func update(_delta: float) -> void:
	if DialogueManager.is_dialogue_active:
		return
	
	movement_vector = get_movement_vector()
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		player.set_moving(true)
		player.update_blend_position(movement_vector)
	else:
		player.set_moving(false)
		
	player.velocity_component.accelerate_in_direction(movement_vector)
	player.velocity_component.move(player)


func exit() -> void:
	pickup_area.monitoring = false


func get_movement_vector():
	var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")	
	direction.y /= 2
	direction = direction.normalized()
	
	return direction
