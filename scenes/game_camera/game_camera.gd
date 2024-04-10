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
	var map_cellsize = tile_map.tile_set.tile_size
	limit_left = map_limits.position.x * map_cellsize.x
	limit_right = map_limits.end.x * map_cellsize.x
	limit_top = map_limits.position.y * map_cellsize.y
	limit_bottom = map_limits.end.y * map_cellsize.y
	
	if not custom_limit_left == 0:
		limit_left = custom_limit_left
	if not custom_limit_right == 0:
		limit_right = custom_limit_right
	if not custom_limit_top == 0:
		limit_top = custom_limit_top
	if not custom_limit_bottom == 0:
		limit_bottom = custom_limit_bottom
