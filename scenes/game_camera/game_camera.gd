extends Camera2D

@onready var tile_map: TileMap = $"../TileMap"

@export var custom_limit_left: int
@export var custom_limit_right: int
@export var custom_limit_top: int
@export var custom_limit_bottom: int

var target_position = Vector2.ZERO


func _ready():
	make_current()
	set_camera_limits()


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func acquire_target():
	var player = PartyManager.get_active_member()
	target_position = player.global_position


func set_camera_limits():
	var map_limits = tile_map.get_used_rect()

	var local_left = tile_map.map_to_local(
		Vector2i(map_limits.position.x, map_limits.size.y))
	var local_right = tile_map.map_to_local(
		Vector2i(map_limits.size.x, map_limits.position.y))
	var local_top = tile_map.map_to_local(map_limits.position)
	var local_bottom = tile_map.map_to_local(map_limits.size)

	limit_left = local_left.x
	limit_right = local_right.x
	limit_top = local_top.y
	limit_bottom = local_bottom.y
	
	if not custom_limit_left == 0:
		limit_left = custom_limit_left
	if not custom_limit_right == 0:
		limit_right = custom_limit_right
	if not custom_limit_top == 0:
		limit_top = custom_limit_top
	if not custom_limit_bottom == 0:
		limit_bottom = custom_limit_bottom
