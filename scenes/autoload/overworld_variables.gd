extends Node

var active_plane: OverworldPlane

var player_map_position: Vector2i = Vector2i.ZERO:
	set(value):
		previous_map_position = player_map_position
		player_map_position = value
var previous_map_position: Vector2i = Vector2i.ZERO
var player: OverworldPlayer

#"dungeon_id": {
#	"entered": true
#}
var dungeons: Dictionary = {}


func vector_to_previous_position():
	return previous_map_position - player_map_position


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
	if (
		data.has("active_plane_path") 
		and data["active_plane_path"] != null
	):
		active_plane = load(data["active_plane_path"]).instantiate()
	
	player_map_position = Vector2(
		data["player_map_position.x"], data["player_map_position.y"])
	
	if (
		data.has("dungeons")
		and data["dungeons"] != null
	):
		dungeons = data.get("dungeons")
