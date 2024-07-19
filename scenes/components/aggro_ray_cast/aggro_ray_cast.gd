extends FloorDetectorRayCast

signal player_detected

@export var aggro_range: float


func _physics_process(_delta):
	var direction = get_direction_to_target()
	if direction == null:
		return
	
	target_position = direction * aggro_range
	
	if is_colliding():
		var collider = get_collider()
		if collider is Player:
			player_detected.emit()


func get_direction_to_target():
	var player = PartyManager.get_active_member()
	if player == null:
		return
	
	var target = player.global_position
	
	return global_position.direction_to(target)
