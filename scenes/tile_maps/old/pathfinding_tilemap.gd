extends TileMap

enum Tile { OBSTACLE, START_POINT, END_POINT }

const CELL_SIZE = Vector2(32, 32)

# The object for pathfinding on 2D grids.
var _astar = AStarGrid2D.new()

var _start_point = Vector2i()
var _end_point = Vector2i()
var _path : Array[Vector2i]

func _ready():
	_astar.region = get_used_rect()
	_astar.cell_size = CELL_SIZE
	_astar.offset = CELL_SIZE * 0.5 # offset to center of each cell
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()
	
	# first tileset atlas source (0) is for obstacles
	for i in range(_astar.region.position.x, _astar.region.end.x):
		for j in range(_astar.region.position.y, _astar.region.end.y):
			var pos = Vector2i(i, j)
			if get_cell_source_id(1, pos) == Tile.OBSTACLE:
				_astar.set_point_solid(pos)


func round_local_position(local_position):
	return map_to_local(local_to_map(local_position))


func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false


func clear_path():
	if not _path.is_empty():
		_path.clear()
		erase_cell(2, _start_point)
		erase_cell(2, _end_point)


func find_path(local_start_point, local_end_point) -> Array[Vector2i]:
	clear_path()

	_start_point = local_to_map(local_start_point)
	_end_point = local_to_map(local_end_point)
	_path = _astar.get_id_path(_start_point, _end_point) 

	# second and third tileset atlas sources are for the start and end point tiles
	if not _path.is_empty():
		set_cell(2, _start_point, Tile.START_POINT, Vector2i(6, 0))
		set_cell(2, _end_point, Tile.END_POINT, Vector2i(7, 0))

	# returns an array of local coordinates
	return _path.duplicate()
