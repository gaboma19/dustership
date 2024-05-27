extends PanelContainer

@onready var map_tiles: TileMap = $EchelonMapTiles
@onready var map_pin_scene = preload("res://scenes/ui/pause_screen/map/map_pin.tscn")


func _process(_delta):
	var movement_vector = get_movement_vector()
	map_tiles.translate(movement_vector)


func get_movement_vector() -> Vector2:
	var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	
	return direction * -3


func draw_pin(cell: Vector2i):
	var pin_position = map_tiles.map_to_local(cell)
	var map_pin = map_pin_scene.instantiate()
	map_tiles.add_child(map_pin)
	map_pin.position = pin_position

	map_tiles.position = (map_pin.position * -3) + (size / 2)


func set_map_tiles(map_tile_scene: PackedScene):
	var map = map_tile_scene.instantiate()
	add_child(map)
	map_tiles = map
