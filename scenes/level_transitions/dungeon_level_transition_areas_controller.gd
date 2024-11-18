extends Node2D

@onready var level_transition_area_north: LevelTransitionArea = \
	$DungeonLevelTransitionAreaNorth
@onready var level_transition_area_south: LevelTransitionArea = \
	$DungeonLevelTransitionAreaSouth
@onready var level_transition_area_west: LevelTransitionArea = \
	$DungeonLevelTransitionAreaWest
@onready var level_transition_area_east: LevelTransitionArea = \
	$DungeonLevelTransitionAreaEast


func set_transition_area_scene_path(neighbor: Room, direction: Vector2i):
	var opposite_position: Vector2i = direction * -1
	var level_transition_area: LevelTransitionArea
	
	match direction:
		Vector2i.UP:
			level_transition_area = level_transition_area_north
		Vector2i.DOWN:
			level_transition_area = level_transition_area_south
		Vector2i.LEFT:
			level_transition_area = level_transition_area_west
		Vector2i.RIGHT:
			level_transition_area = level_transition_area_east
	
	level_transition_area.path = neighbor.scene_path
	level_transition_area.neighbor = neighbor
	level_transition_area.new_player_position = \
		neighbor.layout_positions[opposite_position]
