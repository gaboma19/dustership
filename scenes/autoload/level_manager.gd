extends Node

@onready var map_tiles = $MapTiles


func create_dungeon():
	map_tiles.create_map()
	populate_rooms()


func get_scene(position: Vector2i) -> String:
	var room: Room = map_tiles.map.get(position)
	
	return room.scene_path


func populate_rooms():
	var map = map_tiles.map
	
	for pos in map.keys():
		var room: Room = map.get(pos)
		var path = get_random_scene_path()
		room.scene_path = path


# picks a random random_room scene path
# from 4 variations in the folder /echelon_random/
func get_random_scene_path() -> String:
	return "res://scenes/levels/echelon/echelon_random/echelon_random.tscn"


# returns the tilemap from $MapTiles after the rooms are generated
# to be copied to the pause screen menu
func get_tile_map_pattern() -> TileMapPattern:
	return TileMapPattern.new()


# returns the local map position of the player to place the map pin
func get_player_dungeon_position() -> Vector2i:
	return Vector2i.ZERO
