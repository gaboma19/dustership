extends FloorDetectorRayCast

signal player_detected
signal player_lost

@export var aggro_range: float

var is_player_detected: bool


func _physics_process(_delta):
	var direction = get_direction_to_target()
	if direction == null:
		return
	
	target_position = direction * aggro_range
	
	if is_colliding():
		var collider = get_collider()
		if collider is Player:
			if not is_player_detected:
				is_player_detected = true
				player_detected.emit()
		else:
			# collider is the tilemap
			if is_player_detected:
				is_player_detected = false
				player_lost.emit()


func get_direction_to_target():
	var player = PartyManager.get_active_member()
	if player == null:
		return
	
	var target = player.global_position
	
	return global_position.direction_to(target)


func set_casting(value: bool):
	set_physics_process(value)
