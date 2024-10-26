extends Node2D

@onready var level_transition_area_north: LevelTransitionArea = $DungeonLevelTransitionAreaNorth
@onready var level_transition_area_south: LevelTransitionArea = $DungeonLevelTransitionAreaSouth
@onready var level_transition_area_west: LevelTransitionArea = $DungeonLevelTransitionAreaWest
@onready var level_transition_area_east: LevelTransitionArea = $DungeonLevelTransitionAreaEast


func set_transition_area_scene_path(neighbor: Room, direction: Vector2i):
	match direction:
		Vector2i.UP:
			level_transition_area_north.path = neighbor.scene_path
			level_transition_area_north.neighbor = neighbor
			level_transition_area_north.new_player_position = \
				neighbor.layout_positions[Vector2i.DOWN]
		Vector2i.DOWN:
			level_transition_area_south.path = neighbor.scene_path
			level_transition_area_south.neighbor = neighbor
			level_transition_area_south.new_player_position = \
				neighbor.layout_positions[Vector2i.UP]
		Vector2i.LEFT:
			level_transition_area_west.path = neighbor.scene_path
			level_transition_area_west.neighbor = neighbor
			level_transition_area_west.new_player_position = \
				neighbor.layout_positions[Vector2i.RIGHT]
		Vector2i.RIGHT:
			level_transition_area_east.path = neighbor.scene_path
			level_transition_area_east.neighbor = neighbor
			level_transition_area_east.new_player_position = \
				neighbor.layout_positions[Vector2i.LEFT]
