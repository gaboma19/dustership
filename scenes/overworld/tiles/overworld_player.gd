extends Sprite2D
class_name OverworldPlayer

@export var overworld_tile_map: TileMap

var current_cell: Vector2i = Vector2i.ZERO


func move(vector: Vector2i):
	var new_cell = current_cell + vector
	
	if overworld_tile_map.is_cell_walkable(new_cell):
		current_cell = new_cell
		var new_position = overworld_tile_map.map_to_global(new_cell)
		global_position = new_position
