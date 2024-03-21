extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var velocity_component = $VelocityComponent


func _ready():
	pass
	
	
func _process(_delta):
	var movement_vector = get_movement_vector()
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		set_moving(true)
		update_blend_position(movement_vector)
	else:
		set_moving(false)
		
	velocity_component.accelerate_in_direction(movement_vector)
	velocity_component.move(self)
	
	
func get_movement_vector():
	var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")	
	direction.y /= 2
	direction = direction.normalized()
	
	return direction
	
	
func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)
	
	
func update_blend_position(direction: Vector2):
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Walk/blend_position"] = direction
