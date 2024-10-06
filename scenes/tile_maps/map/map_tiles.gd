extends TileMapLayer

const TERRAIN = 0
const TERRAIN_SET = 0
const SOURCE_ID = 1

var map: Dictionary = {}

@onready var map_generator: MapGenerator = $MapGenerator
@onready var control: Control = get_parent()


func create_map():
	var s = generate_seed()
	map = map_generator.generate(s)
	
	load_map()
	set_control_size()


func generate_seed() -> int:
	var time_seed = int(Time.get_unix_time_from_system())
	var random_seed = randi()
	return time_seed + random_seed


func load_map():
	self.clear()
	
	for pos in map.keys():
		var room: Room = map.get(pos)
		
		for k in room.neighbors.keys():
			if room.neighbors[k] != null:
				var neighbor_pos = pos + (k as Vector2i)
				var path: Array[Vector2i] = [pos, neighbor_pos]
				set_cells_terrain_path(path, TERRAIN_SET, TERRAIN)


func set_control_size():
	var tile_size = tile_set.tile_size
	var rect = get_used_rect()
	var size = rect.size * tile_size
	var offset = rect.position * tile_size * -1
	
	control.custom_minimum_size = size
	position.x = offset.x
	position.y = offset.y


func draw_player_token(coords: Vector2i):
	const ALTERNATIVE_TILE = 1
	var atlas_coords: Vector2i = get_cell_atlas_coords(coords)
	
	set_cell(coords, SOURCE_ID, atlas_coords, ALTERNATIVE_TILE)
