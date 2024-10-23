extends Camera2D

var target_position = Vector2.ZERO


func _ready():
	make_current()


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func acquire_target():
	var player = PartyManager.get_active_member()
	if player == null:
		target_position = global_position
		return
	target_position = player.global_position
