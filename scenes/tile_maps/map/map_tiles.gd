extends TileMap

const TERRAIN_ID = 0

var map: Dictionary = {}

@onready var map_generator: MapGenerator = $MapGenerator


func _ready():
	var seed = generate_seed()
	map = map_generator.generate(seed)
	
	load_map()


func generate_seed() -> int:
	var time_seed = int(Time.get_unix_time_from_system())
	var random_seed = randi()
	return time_seed + random_seed


func load_map():
	self.clear()
	
	for pos in map.keys():
		var room: Room = map.get(pos)
		for neighbor in room.neighbors:
			if neighbor != null:
				var path: Array[Vector2i] = [pos, neighbor]
				set_cells_terrain_path(TERRAIN_ID, path, TERRAIN_ID, TERRAIN_ID)
