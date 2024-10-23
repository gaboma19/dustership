extends PanelContainer

@onready var map_pin_scene = preload("res://scenes/ui/pause_screen/map/map_pin.tscn")
@onready var map_tiles: TileMapLayer = $MapTiles


func _ready():
	load_map()


func _process(_delta):
	var movement_vector = get_movement_vector()
	map_tiles.translate(movement_vector)


func load_map():
	var pattern = DungeonManager.get_tile_map_pattern()
	map_tiles.set_pattern(Vector2i(0, 0), pattern)


func get_movement_vector() -> Vector2:
	var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	
	return direction * -3
