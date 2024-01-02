extends CharacterBody2D

var direction = Vector2()

const TOP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)

var speed = 0
const MAX_SPEED = 2000
const FRICTION_FACTOR = 0.89

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

func _physics_process(delta):
	# this can be simplified by grouping them in input map settings
	var is_moving = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left")
	
	if is_moving:
		speed = MAX_SPEED
		
		if Input.is_action_pressed("move_up"):
			direction = TOP
		elif Input.is_action_pressed("move_right"):
			direction = RIGHT
		elif Input.is_action_pressed("move_down"):
			direction = DOWN
		elif Input.is_action_pressed("move_left"):
			direction = LEFT
		pass
	else:
		speed = 0
		
	velocity = speed * direction * delta
	velocity *= FRICTION_FACTOR
	velocity = cartesian_to_isometric(velocity)
	
	move_and_slide()
	

