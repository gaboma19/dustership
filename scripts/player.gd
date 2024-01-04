extends CharacterBody2D

var direction = Vector2()
const MOTION_SPEED = 30

@onready var animation_tree : AnimationTree = $AnimationTree

func _ready():
	animation_tree.active = true
	
func _process(_delta):
	if (direction != Vector2.ZERO):
		set_moving(true)
		update_blend_position()
	else:
		set_moving(false)
		
func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)
	
func update_blend_position():
	animation_tree["parameters/Idle/blend_position"] = direction
	animation_tree["parameters/Walk/blend_position"] = direction

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

func _physics_process(delta):		
	direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	
	# direction = cartesian_to_isometric(direction)
	direction.y /= 2
	direction = direction.normalized()
	
	velocity = direction * MOTION_SPEED
	
	move_and_slide()
