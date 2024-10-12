extends Node

var player_dungeon_position: Vector2i = Vector2i.ZERO:
	get:
		return player_dungeon_position
	set(coords):
		map_tiles.erase_player_tile(player_dungeon_position)
		player_dungeon_position = coords
		map_tiles.draw_player_tile(coords)

@onready var map_tiles: TileMapLayer = %MapTiles


func _ready():
	map_tiles.clear()


func create():
	map_tiles.create_map()
	populate_rooms()


func clear():
	player_dungeon_position = Vector2i.ZERO
	map_tiles.clear_map()


func get_room(position: Vector2i) -> Room:
	return map_tiles.map.get(position)


func get_scene(position: Vector2i) -> String:
	var room: Room = map_tiles.map.get(position)
	
	return room.scene_path


func populate_rooms():
	var map = map_tiles.map
	
	for pos in map.keys():
		var room: Room = map.get(pos)
		
		var path = get_random_scene_path()
		room.scene_path = path
		
		room.map_position = pos


## picks a random random_room scene path
## from variations in the folder /echelon_random/
func get_random_scene_path() -> String:
	return "res://scenes/levels/echelon/echelon_dungeon/echelon_dungeon_level.tscn"
