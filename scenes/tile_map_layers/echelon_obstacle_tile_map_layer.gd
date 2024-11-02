extends TileMapLayer

enum Patterns { VERTICAL, HORIZONTAL }

@export var echelon_tile_map_layers: Node2D

var obstacles: Array[Obstacle]
var north_door_position: Vector2i
var south_door_position: Vector2i
var west_door_position: Vector2i
var east_door_position: Vector2i


func _ready():
	child_entered_tree.connect(on_child_entered_tree)
	
	north_door_position = Vector2i(
		2 * echelon_tile_map_layers.north_door_position.x + 1, 
		2 * echelon_tile_map_layers.north_door_position.y + 3)
	south_door_position = Vector2i(
		2 * echelon_tile_map_layers.north_door_position.x + 1,
		2 * echelon_tile_map_layers.south_door_position.y + 2)
	west_door_position = Vector2i(
		2 * echelon_tile_map_layers.west_door_position.x + 3,
		2 * echelon_tile_map_layers.west_door_position.y + 1)
	east_door_position = Vector2i(
		2 * echelon_tile_map_layers.east_door_position.x + 2,
		2 * echelon_tile_map_layers.east_door_position.y + 1)


func open_doors():
	for o in obstacles:
		o.lower()


func close_doors():
	for o in obstacles:
		o.rise()


func paste_doorway(direction: Vector2i):
	var pattern: TileMapPattern
	var door_position: Vector2i
	
	match direction:
		Vector2i.UP:
			pattern = tile_set.get_pattern(Patterns.HORIZONTAL)
			door_position = north_door_position
		Vector2i.DOWN:
			pattern = tile_set.get_pattern(Patterns.HORIZONTAL)
			door_position = south_door_position
		Vector2i.LEFT:
			pattern = tile_set.get_pattern(Patterns.VERTICAL)
			door_position = west_door_position
		Vector2i.RIGHT:
			pattern = tile_set.get_pattern(Patterns.VERTICAL)
			door_position = east_door_position
	
	set_pattern(door_position, pattern)


func on_child_entered_tree(child: Node):
	await child.ready
	
	if child is Obstacle:
		obstacles.append(child)
