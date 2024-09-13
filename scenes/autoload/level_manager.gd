extends Node

@onready var map_tiles = $MapTiles


# called by overworld_combat_tile
func create_dungeon():
	map_tiles.create_map()
	populate_rooms()


func get_scene(position: Vector2i) -> String:
	var room: Room = map_tiles.map.get(position)
	
	return room.scene_path


# assigns references to level scene paths for each position on the map
# populates a Dictionary { map position: scene path string }
# the scene path dictionary is looked up by level transition areas in each room
func populate_rooms():
	pass


# returns the tilemap from $MapTiles after the rooms are generated
# to be copied to the pause screen menu
func get_tile_map_pattern() -> TileMapPattern:
	return TileMapPattern.new()


# returns the local map position of the player to place the map pin
func get_player_map_position() -> Vector2i:
	return Vector2i.ZERO
