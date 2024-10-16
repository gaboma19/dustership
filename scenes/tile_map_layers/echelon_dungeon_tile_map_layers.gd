extends Node2D

enum Patterns { NORTH, EAST, SOUTH, WEST, CLIFF_WEST, CLIFF_EAST }

@export var north_door_position: Vector2i
@export var south_door_position: Vector2i
@export var west_door_position: Vector2i
@export var east_door_position: Vector2i
@export var west_cliffs_position: Vector2i
@export var east_cliffs_position: Vector2i

@onready var floor_layer: TileMapLayer = get_node("floor")
@onready var cliffs_layer: TileMapLayer = get_node("cliffs")
@onready var tile_set: TileSet = floor_layer.tile_set


func paste_doorway(direction: Vector2i):
	var pattern: TileMapPattern
	var door_position: Vector2i
	var cliffs_pattern: TileMapPattern
	var cliffs_position: Vector2i
	
	match direction:
		Vector2i.UP:
			pattern = tile_set.get_pattern(Patterns.NORTH)
			door_position = north_door_position
		Vector2i.DOWN:
			pattern = tile_set.get_pattern(Patterns.SOUTH)
			door_position = south_door_position
		Vector2i.LEFT:
			pattern = tile_set.get_pattern(Patterns.WEST)
			door_position = west_door_position
			
			cliffs_pattern = tile_set.get_pattern(Patterns.CLIFF_WEST)
			cliffs_position = west_cliffs_position
			cliffs_layer.set_pattern(cliffs_position, cliffs_pattern)
		Vector2i.RIGHT:
			pattern = tile_set.get_pattern(Patterns.EAST)
			door_position = east_door_position
			
			cliffs_pattern = tile_set.get_pattern(Patterns.CLIFF_EAST)
			cliffs_position = east_cliffs_position
			cliffs_layer.set_pattern(cliffs_position, cliffs_pattern)
	
	floor_layer.set_pattern(door_position, pattern)
