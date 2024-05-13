# active.gd
extends PlayerState

@onready var pickup_area = %PickupArea
@onready var collision_shape_2d = %CollisionShape2D

var movement_vector: Vector2 = Vector2.ZERO


func enter(_msg := {}) -> void:
	pickup_area.set_deferred("monitorable", true)
	collision_shape_2d.disabled = false


func update(_delta: float) -> void:
	if DialogueManager.is_dialogue_active:
		return
	
	movement_vector = get_movement_vector()
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		player.set_moving(true)
		player.update_blend_position(movement_vector)
		player.velocity_component.accelerate_in_direction(movement_vector)
	else:
		player.set_moving(false)
		player.velocity_component.decelerate()
	
	player.velocity_component.move(player)


func handle_input(event):
	if DialogueManager.is_dialogue_active:
		return
	
	if event.is_action_pressed("attack") \
	&& player.animation_state_machine.get_current_node() != "Attack" \
	&& player.animation_state_machine.get_current_node() != "Charge" \
	&& player.can_attack() \
	&& player.state_machine.state == self:
		state_machine.transition_to("Attack")
	
	if event.is_action_pressed("dodge") \
	&& player.character_name == Constants.CharacterNames.APRIL \
	&& player.state_machine.state == self:
		state_machine.transition_to("Dodge")


func get_movement_vector():
	var direction = Input.get_vector(
		"move_left", "move_right", "move_up",  "move_down")
	
	return direction
