extends Node2D

signal plane_changed(next_plane: PackedScene)

enum Tile { FLOOR, WALL }

const CELL_SIZE = Vector2(32, 32)

# The object for pathfinding on 2D grids.
var astar = AStarGrid2D.new()

var start_point = Vector2i()
var end_point = Vector2i()
var path : Array[Vector2i]

@onready var animation_player = $AnimationPlayer


func _ready():
	astar.region = get_used_rect()
	astar.cell_size = CELL_SIZE
	astar.offset = CELL_SIZE * 0.5 # offset to center of each cell
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for i in range(astar.region.position.x, astar.region.end.x):
		for j in range(astar.region.position.y, astar.region.end.y):
			var pos = Vector2i(i, j)
			if get_cell_source_id(Tile.WALL, pos) == Tile.WALL:
				astar.set_point_solid(pos)
			
			if get_cell_source_id(Tile.FLOOR, pos) == -1:
				astar.set_point_solid(pos)
	
	var ladders: Array[Node] = get_tree().get_nodes_in_group("ladders")
	for ladder in ladders:
		ladder.ladder_activated.connect(on_ladder_activated)


func find_path(local_start_point, local_end_point) -> Array[Vector2i]:
	path.clear()

	start_point = local_to_map(local_start_point)
	end_point = local_to_map(local_end_point)
	path = astar.get_id_path(start_point, end_point) 

	# returns an array of local coordinates
	return path.duplicate()


func is_cell_walkable(map_position: Vector2i) -> bool:
	if astar.is_in_boundsv(map_position):
		return not astar.is_point_solid(map_position)
	return false


func map_to_global(map_position: Vector2i) -> Vector2:
	return to_global(map_to_local(map_position))


func exit():
	# calls queue_free()
	animation_player.play("fly_away")


func enter():
	animation_player.play("fade_in")


func on_ladder_activated(next_plane: PackedScene):
	plane_changed.emit(next_plane)
