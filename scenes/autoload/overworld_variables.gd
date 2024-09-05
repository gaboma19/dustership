extends Node

var active_layer: TileMap

var player_map_position: Vector2i = Vector2i.ZERO

#"ingress_id": {
#	"entered": true
#}
var ingresses: Dictionary = {}


func save_data() -> Dictionary:
	var data = {
		"active_layer" = active_layer.scene_file_path,
		"player_map_position.x" = player_map_position.x,
		"player_map_position.y" = player_map_position.y,
		"ingresses" = ingresses
	}
	
	return data


func load_data(data: Dictionary):
	active_layer = load(data["active_layer"]).instantiate()
	player_map_position = Vector2(
		data["player_map_position.x"], data["player_map_position.y"])
	ingresses = data["ingresses"]
