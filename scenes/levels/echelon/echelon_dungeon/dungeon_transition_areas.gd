extends Node2D

@onready var level_transition_area_north: Area2D = $LevelTransitionAreaNorth
@onready var level_transition_area_south: Area2D = $LevelTransitionAreaSouth
@onready var level_transition_area_west: Area2D = $LevelTransitionAreaWest
@onready var level_transition_area_east: Area2D = $LevelTransitionAreaEast


func set_doorways(room: Room):
	for direction in room.neighbors.keys():
		if room.neighbors[direction] != null:
			set_transition_area_scene_path(room.neighbors[direction], direction)


func set_transition_area_scene_path(neighbor: Room, direction: Vector2i):
	match direction:
		Vector2i.UP:
			level_transition_area_north.path = neighbor.scene_path
			level_transition_area_north.neighbor = neighbor
		Vector2i.DOWN:
			level_transition_area_south.path = neighbor.scene_path
			level_transition_area_south.neighbor = neighbor
		Vector2i.LEFT:
			level_transition_area_west.path = neighbor.scene_path
			level_transition_area_west.neighbor = neighbor
		Vector2i.RIGHT:
			level_transition_area_east.path = neighbor.scene_path
			level_transition_area_east.neighbor = neighbor
