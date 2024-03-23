extends CharacterBody2D

enum State { IDLE, FOLLOW, MOVING }

const ARRIVE_DISTANCE = 1

@export var speed: float = 30.0

var _state = State.IDLE
var _direction = Vector2()

@onready var _animation_tree : AnimationTree = $AnimationTree
@onready var _tile_map = $"../TileMap"

var _click_position = Vector2()
var _path : Array[Vector2i]
var _next_point = Vector2i()


func _ready():
	_change_state(State.IDLE)
	_animation_tree.active = true


func _process(_delta):
	if _state == State.FOLLOW:
		var arrived_to_next_point = _move_to(_next_point)
		if arrived_to_next_point:
			_path.remove_at(0)
		if _path.is_empty():
			_change_state(State.IDLE)
			return
		_next_point = _tile_map.map_to_local(_path[0])
		
		_set_moving(true)
		_update_blend_position()
	elif _state == State.IDLE:
		_set_moving(false)
	elif _state == State.MOVING:
		_set_moving(true)
		_update_blend_position()
		
		
func _set_moving(value):
	_animation_tree.set("parameters/conditions/is_idle", not value)
	_animation_tree.set("parameters/conditions/is_moving", value)
	
	
func _update_blend_position():
	_animation_tree["parameters/Idle/blend_position"] = _direction
	_animation_tree["parameters/Walk/blend_position"] = _direction
	
	
func _unhandled_input(event):
	_click_position = get_global_mouse_position()
	if _tile_map.is_point_walkable(_click_position):
		if event.is_action_pressed(&"move_to"):
			_change_state(State.FOLLOW)
	
	
func _move_to(local_position):
	_direction = position.direction_to(local_position)
	velocity = _direction * speed
	
	var has_arrived = position.distance_to(local_position) < ARRIVE_DISTANCE
	if not has_arrived:
		move_and_slide()
	return has_arrived
	
	
func _change_state(new_state):
	if new_state == State.IDLE:
		_tile_map.clear_path()
	elif new_state == State.FOLLOW:
		_path = _tile_map.find_path(position, _click_position)
		if _path.size() < 2:
			_change_state(State.IDLE)
			return
		# The index 0 is the starting cell.
		# We don't want the character to move back to it in this example.
		_next_point = _tile_map.map_to_local(_path[1])
	_state = new_state


func _physics_process(_delta):
	_direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	
	if (_direction.is_equal_approx(Vector2.ZERO)):
		if (_state != State.FOLLOW):
			_change_state(State.IDLE)
	else:
		_change_state(State.MOVING)
	
	_direction.y /= 2
	_direction = _direction.normalized()
	
	velocity = _direction * speed
	
	move_and_slide()
	
#func _cartesian_to_isometric(cartesian):
	#return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)
