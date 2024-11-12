extends Node

var active_plane: TileMap

var player_map_position: Vector2i = Vector2i.ZERO

#"dungeon_id": {
#	"entered": true
#}
var dungeons: Dictionary = {}


func save_data() -> Dictionary:
	var active_plane_path = null
	if active_plane != null:
		active_plane_path = active_plane.scene_file_path
	
	var data = {
		"active_plane_path" = active_plane_path,
		"player_map_position.x" = player_map_position.x,
		"player_map_position.y" = player_map_position.y,
		"dungeons" = dungeons
	}
	
	return data


func load_data(data: Dictionary):
	if data["active_plane_path"] != null:
		active_plane = load(data["active_plane_path"]).instantiate()
	
	player_map_position = Vector2(
		data["player_map_position.x"], data["player_map_position.y"])
	
	dungeons = data["dungeons"]
