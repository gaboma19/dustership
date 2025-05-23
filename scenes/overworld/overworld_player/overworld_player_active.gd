extends State

var is_keyboard_mouse_controls: bool = false

@onready var player = owner as OverworldPlayer


func enter(_msg := {}) -> void:
	player.mouse_detectors.mouse_entered.connect(on_mouse_entered)
	player.mouse_detectors.mouse_clicked.connect(on_mouse_clicked)


func exit() -> void:
	player.mouse_detectors.mouse_entered.disconnect(on_mouse_entered)
	player.mouse_detectors.mouse_clicked.disconnect(on_mouse_clicked)


func handle_input(event: InputEvent) -> void:
	if player.is_moving:
		return
	
	if event is InputEventMouseMotion:
		is_keyboard_mouse_controls = true
	if event is InputEventJoypadMotion:
		is_keyboard_mouse_controls = false
	
	if event.is_action_pressed("interact"):
		get_tree().root.set_input_as_handled()
		player.move_to_selected_tile()
		return
	
	var vector = get_movement_vector()
	var direction = map_vector_to_direction(vector)
	
	if direction == Vector2i.ZERO and is_keyboard_mouse_controls:
		return
	
	if is_keyboard_mouse_controls:
		player.select_from_selected_position(direction)
	else:
		player.select_from_player_position(direction)


func on_mouse_entered(vector: Vector2i):
	player.select_from_player_position(vector)


func on_mouse_clicked(vector: Vector2i):
	player.move_in_direction(vector)


func get_movement_vector():
	var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	return cartesian_to_isometric(direction)


func cartesian_to_isometric(direction):
	const X_ROTATION = deg_to_rad(27)
	const Y_ROTATION = deg_to_rad(63)
	
	var iso_x = direction.x * cos(X_ROTATION) - direction.y * cos(Y_ROTATION)
	var iso_y = direction.x * sin(X_ROTATION) + direction.y * sin(Y_ROTATION)
	
	return Vector2(iso_x, iso_y)


func map_vector_to_direction(vector: Vector2) -> Vector2i:
	var x = vector.x
	var y = vector.y
	if x == 0 and y == 0:
		return Vector2i.ZERO
	elif y > 0:
		if x > 0:
			return Vector2i.RIGHT
		else:
			return Vector2i.DOWN
	else:
		if x > 0:
			return Vector2i.UP
		else:
			return Vector2i.LEFT
