extends Node2D

@onready var level_transition_area_north = $LevelTransitionAreaNorth
@onready var level_transition_area_south = $LevelTransitionAreaSouth
@onready var level_transition_area_west = $LevelTransitionAreaWest
@onready var level_transition_area_east = $LevelTransitionAreaEast


func set_doorways(room: Room):
	for direction in room.neighbors.keys():
		if room.neighbors[direction] != null:
			set_transition_area_scene_path(room.neighbors[direction], direction)


func set_transition_area_scene_path(neighbor: Room, direction: Vector2i):
	match direction:
		Vector2i.UP:
			level_transition_area_north.path = neighbor.scene_path
		Vector2i.DOWN:
			level_transition_area_south.path = neighbor.scene_path
		Vector2i.LEFT:
			level_transition_area_west.path = neighbor.scene_path
		Vector2i.RIGHT:
			level_transition_area_east.path = neighbor.scene_path
