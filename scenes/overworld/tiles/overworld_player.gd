extends Sprite2D
class_name OverworldPlayer

var active_map: TileMap


func move(vector: Vector2i):
	var new_cell = OverworldVariables.player_map_position + vector
	
	if active_map.is_cell_walkable(new_cell):
		OverworldVariables.player_map_position = new_cell
		var new_position = active_map.map_to_global(new_cell)
		global_position = new_position
