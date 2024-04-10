extends PanelContainer

@onready var map_tiles: TileMap = $EchelonMapTiles
@onready var map_pin_scene = preload("res://scenes/ui/pause_screen/map_pin.tscn")


func _process(_delta):
	var movement_vector = get_movement_vector()
	map_tiles.translate(movement_vector)
	map_tiles.position.x = clamp(
		map_tiles.position.x, map_tiles.map_x_minimum, map_tiles.map_x_maximum)
	map_tiles.position.y = clamp(
		map_tiles.position.y, map_tiles.map_y_minimum, map_tiles.map_y_maximum)


func get_movement_vector() -> Vector2:
	var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	
	return direction * -3


func draw_pin(cell: Vector2i):
	var pin_position = map_tiles.map_to_local(cell)
	var map_pin = map_pin_scene.instantiate()
	map_tiles.add_child(map_pin)
	map_pin.position = pin_position


func set_map_tiles(map_tile_scene: PackedScene):
	var map = map_tile_scene.instantiate()
	add_child(map)
	map_tiles = map
