extends CharacterBody2D

enum State { IDLE, FOLLOW }

const ARRIVE_DISTANCE = 10.0

@export var speed: float = 30.0

var _state = State.IDLE
var _direction = Vector2()

@onready var _animation_tree : AnimationTree = $AnimationTree
@onready var _tile_map = $"../TileMap"

var _click_position = Vector2()
var _path = PackedVector2Array()
var _next_point = Vector2()

func _ready():
	_animation_tree.active = true
	
func _process(_delta):
	if (_direction != Vector2.ZERO):
		_set_moving(true)
		_update_blend_position()
	else:
		_set_moving(false)
		
func _set_moving(value):
	_animation_tree.set("parameters/conditions/is_idle", not value)
	_animation_tree.set("parameters/conditions/is_moving", value)
	
func _update_blend_position():
	_animation_tree["parameters/Idle/blend_position"] = _direction
	_animation_tree["parameters/Walk/blend_position"] = _direction
	
func _move_to(local_position):
	_direction = position.direction_to(local_position)
	velocity = _direction * speed
	
	var has_arrived = position.distance_to(local_position) < ARRIVE_DISTANCE
	if not has_arrived:
		move_and_slide()
	return has_arrived

#func _cartesian_to_isometric(cartesian):
	#return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

func _physics_process(_delta):
	_direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	
	#_direction = _cartesian_to_isometric(_direction)
	_direction.y /= 2
	_direction = _direction.normalized()
	
	velocity = _direction * speed 
	
	move_and_slide()
