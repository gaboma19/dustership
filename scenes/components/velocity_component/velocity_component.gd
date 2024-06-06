extends Node
class_name VelocityComponent

signal arrived

@export var max_speed: int = 40
@export var acceleration: float = 5

var velocity = Vector2.ZERO
var is_on_up_ramp: bool = false
var is_on_down_ramp: bool = false
var is_decelerating: bool = false
var is_moving_to_point: bool = false
var point: Vector2


func _process(_delta):
	if is_moving_to_point:
		var distance = owner.global_position.distance_to(point)
		if distance > 1:
			accelerate_to_point(point)
			move(owner)
		else:
			stop()
			is_moving_to_point = false
			arrived.emit()


func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
		
	var player = PartyManager.get_active_member()
	if player == null:
		return
	
	is_decelerating = false
	
	var direction = owner_node2d.global_position.direction_to(
		player.global_position)
	accelerate_in_direction(direction)


func accelerate_to_point(target_point: Vector2):
	is_decelerating = false
	
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var direction = owner_node2d.global_position.direction_to(target_point)
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	if direction != Vector2.ZERO:
		is_decelerating = false
	
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(
		desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func decelerate():
	is_decelerating = true
	accelerate_in_direction(Vector2.ZERO)


func stop():
	if not owner is CharacterBody2D:
		return
	
	is_decelerating = true
	
	owner.velocity = Vector2.ZERO
	owner.move_and_slide()
	velocity = owner.velocity


func apply_ramp_bias():
	if is_decelerating:
		return
	
	if velocity.x < 1 && velocity.x > -1:
		return
	
	if is_on_down_ramp:
		if velocity.x > 0:
			velocity.y += 5.0
		if velocity.x < 0:
			velocity.y -= 5.0
	elif is_on_up_ramp:
		if velocity.x > 0:
			velocity.y -= 5.0
		if velocity.x < 0:
			velocity.y += 5.0


func accelerate_to_point_and_stop(target_point: Vector2):
	is_moving_to_point = true
	point = target_point


func move(character_body: CharacterBody2D):
	apply_ramp_bias()
	
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
