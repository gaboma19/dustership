# telitz_float.gd
extends PlayerState

const MAX_FLOAT_TIME: float = 8.0

@export var float_effect: Node2D
@export var float_attack: Node2D

var movement_vector: Vector2 = Vector2.ZERO
var float_time: float
var land_tween: Tween


func enter(_msg := {}) -> void:
	float_time = 0
	
	update_blend_position(player.blend_position)
	player.animation_state_machine.travel("Float")
	
	player.sprite.offset.y -= 5
	
	float_effect.play()
	float_attack.start()
	
	player.velocity_component.max_speed /= 2
	player.velocity_component.acceleration /= 2


func update(delta: float) -> void:
	float_time += delta
	
	if float_time >= MAX_FLOAT_TIME:
		transition_to_active()
	
	if float_time > 6:
		land()
	
	if DialogueManager.is_dialogue_active:
		# skip movement input
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
	player.update_blend_position(direction)


func get_movement_vector():
	var direction = Input.get_vector(
		"move_left", "move_right", "move_up",  "move_down")
	
	return direction


func land():
	if land_tween != null && land_tween.is_valid():
		return
	
	var final_offset = Vector2(player.sprite.offset.x, player.sprite.offset.y + 5)
	
	land_tween = create_tween()
	land_tween.tween_property(player.sprite, "offset", final_offset, 2.0)


func transition_to_active():
	float_attack.stop()
	player.animation_tree.set("parameters/conditions/is_charging", false)
	
	PartyManager.disable_switch_character(false)
	player.velocity_component.max_speed *= 2
	player.velocity_component.acceleration *= 2
	
	state_machine.transition_to("Active")
