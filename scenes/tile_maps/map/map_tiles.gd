extends TileMapLayer

const TERRAIN = 0
const TERRAIN_SET = 0

var map: Dictionary = {}

@onready var map_generator: MapGenerator = $MapGenerator


func _ready():
	var s = generate_seed()
	map = map_generator.generate(s)
	
	load_map()


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
