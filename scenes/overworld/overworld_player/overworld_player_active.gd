extends State

@onready var player = owner as OverworldPlayer


func update(_float) -> void:
	if not player.is_moving:
		if Input.is_action_just_pressed("move_left"):
			player.move(Vector2i.LEFT)
		elif Input.is_action_just_pressed("move_right"):
			player.move(Vector2i.RIGHT)
		elif Input.is_action_just_pressed("move_up"):
			player.move(Vector2i.UP)
		elif Input.is_action_just_pressed("move_down"):
			player.move(Vector2i.DOWN)
