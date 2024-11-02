extends Node

@onready var map_tiles_copy: TileMapLayer = $MapTilesCopy
@onready var map_icons_copy: TileMapLayer = $MapIconsCopy
@onready var map_tiles: TileMapLayer = %MapTiles
@onready var map_icons: TileMapLayer = %MapIcons
@onready var control: Control = get_parent()


func clear():
	map_tiles_copy.clear()
	map_icons_copy.clear()


func copy_tile(coords: Vector2i):
	var map_atlas_coords = map_tiles.get_cell_atlas_coords(coords)
	var map_alternative_tile = map_tiles.get_cell_alternative_tile(coords)
	var icon_atlas_coords = map_icons.get_cell_atlas_coords(coords)
	
	if map_atlas_coords != Vector2i(-1, -1):
		map_tiles_copy.set_cell(coords, 0, map_atlas_coords, map_alternative_tile)
	if icon_atlas_coords != Vector2i(-1, -1):
		map_icons_copy.set_cell(coords, 1, icon_atlas_coords)
	
	set_control_size()


func set_control_size():
	var tile_size = map_tiles_copy.tile_set.tile_size
	var rect = map_tiles_copy.get_used_rect()
	var size = rect.size * tile_size
	var offset = rect.position * tile_size * -1
	
	size *= 2
	offset *= 2
	
	control.custom_minimum_size = size
	map_tiles_copy.set_position(Vector2(offset.x, offset.y))
	map_icons_copy.set_position(Vector2(offset.x, offset.y))
	map_tiles.set_position(Vector2(offset.x, offset.y))
	map_icons.set_position(Vector2(offset.x, offset.y))
