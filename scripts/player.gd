extends CharacterBody2D

var direction = Vector2()

#const TOP = Vector2(0, -1)
#const RIGHT = Vector2(1, 0)
#const DOWN = Vector2(0, 1)
#const LEFT = Vector2(-1, 0)

const MOTION_SPEED = 30
const FRICTION_FACTOR = 0.89

@onready var animation_tree : AnimationTree = $AnimationTree

func _ready():
	animation_tree.active = true
	
func _process(_delta):
	update_animation_parameters()

func update_animation_parameters():
	if (velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if (direction != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

func _physics_process(delta):
	## this can be simplified by grouping them in input map settings
	#var is_moving = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left")
	#
	#if is_moving:
		#speed = MAX_SPEED
		#
		#if Input.is_action_pressed("move_up"):
			#direction = TOP
		#elif Input.is_action_pressed("move_right"):
			#direction = RIGHT
		#elif Input.is_action_pressed("move_down"):
			#direction = DOWN
		#elif Input.is_action_pressed("move_left"):
			#direction = LEFT
		#pass
	#else:
		#speed = 0
		
	direction = Input.get_vector("move_down", "move_left", "move_right", "move_up")
	direction.y /= 2
	
	velocity += direction.normalized() * MOTION_SPEED
	velocity *= FRICTION_FACTOR
	
	move_and_slide()
	

