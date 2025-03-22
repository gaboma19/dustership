extends State

enum Direction { LEFT, RIGHT, UP, DOWN }

@onready var player = owner as OverworldPlayer


func handle_input(_event: InputEvent) -> void:
	if not player.is_moving:
		var vector = get_movement_vector()
		if vector.x == 0 or vector.y == 0:
			return
		
		var direction = map_vector_to_direction(vector)
		match direction:
			Direction.LEFT:
				player.select(Vector2i.LEFT)
			Direction.RIGHT:
				player.select(Vector2i.RIGHT)
			Direction.UP:
				player.select(Vector2i.UP)
			Direction.DOWN:
				player.select(Vector2i.DOWN)


func get_movement_vector():
	var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	return cartesian_to_isometric(direction)


func cartesian_to_isometric(direction):
	const X_ROTATION = deg_to_rad(27)
	const Y_ROTATION = deg_to_rad(63)
	
	var iso_x = direction.x * cos(X_ROTATION) - direction.y * cos(Y_ROTATION)
	var iso_y = direction.x * sin(X_ROTATION) + direction.y * sin(Y_ROTATION)
	
	return Vector2(iso_x, iso_y)


func map_vector_to_direction(vector: Vector2):
	var x = vector.x
	var y = vector.y
	if y > 0:
		if x > 0:
			return Direction.RIGHT
		else:
			return Direction.DOWN
	else:
		if x > 0:
			return Direction.UP
		else:
			return Direction.LEFT
