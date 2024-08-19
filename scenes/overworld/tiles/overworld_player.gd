extends Sprite2D
class_name OverworldPlayer


func move(vector: Vector2i):
	var active_layer = OverworldVariables.active_layer
	
	var new_cell = OverworldVariables.player_map_position + vector
	
	if active_layer.is_cell_walkable(new_cell):
		OverworldVariables.player_map_position = new_cell
		var new_position = active_layer.map_to_global(new_cell)
		global_position = new_position


func exit():
	queue_free()
