# telitz_float.gd
extends PlayerState

const MAX_FLOAT_TIME: float = 6.0

var movement_vector: Vector2 = Vector2.ZERO
var float_time: float


func enter(_msg := {}) -> void:
	float_time = 0
	player.animation_state_machine.travel("Float")
	update_blend_position(player.blend_position)
	
	player.sprite.offset.y -= 5


func update(delta: float) -> void:
	float_time += delta
	
	if float_time >= MAX_FLOAT_TIME:
		transition_to_active()
	
	if DialogueManager.is_dialogue_active:
		return
	
	movement_vector = get_movement_vector()
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		update_blend_position(movement_vector)
		player.velocity_component.accelerate_in_direction(movement_vector)
	else:
		player.velocity_component.decelerate()
		
	player.velocity_component.move(player)


func update_blend_position(direction: Vector2):
	player.animation_tree["parameters/Float/blend_position"] = direction


func get_movement_vector():
	var direction = Input.get_vector(
		"move_left", "move_right", "move_up",  "move_down")
	
	return direction


func transition_to_active():
	player.animation_tree.set("parameters/conditions/is_charging", false)
	player.sprite.offset.y += 5
	PartyManager.disable_switch_character(false)
	state_machine.transition_to("Active")
