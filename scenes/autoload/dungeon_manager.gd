extends Node

var player_dungeon_position: Vector2i = Vector2i.ZERO:
	get:
		return player_dungeon_position
	set(coords):
		map_tiles.erase_player_tile(player_dungeon_position)
		player_dungeon_position = coords
		map_tiles.draw_player_tile(coords)

@onready var map_tiles: MapTiles = %MapTiles


func _ready():
	map_tiles.clear()
	
	#_test_create()


func create():
	exit()
	map_tiles.create_map()
	populate_rooms()


func exit():
	player_dungeon_position = Vector2i.ZERO
	map_tiles.clear_map()
	EntityVariables.chests.clear()


func get_room(coords: Vector2i) -> Room:
	return map_tiles.map.get(coords)


func get_scene(coords: Vector2i) -> String:
	var room: Room = map_tiles.map.get(coords)
	
	return room.scene_path


func populate_rooms():
	var map = map_tiles.map
	
	for pos in map.keys():
		var room: Room = map.get(pos)
		room.map_position = pos
		
		set_random_scene_path(room)
		room.chest_id = get_chest_id(pos)


func set_random_scene_path(room: Room) -> void:
	randomize()
	
	var layout: Room.Layout = Room.Layout.A if randf() < 0.5 else Room.Layout.B
	var layout_dir: String
	
	match layout:
		Room.Layout.A:
			layout_dir = "res://scenes/levels/dungeon/a/"
		Room.Layout.B:
			layout_dir = "res://scenes/levels/dungeon/b/"
	
	var dir: DirAccess = DirAccess.open(layout_dir)
	var random_file: String
	var index: int
	var file_names: PackedStringArray
	
	if dir:
		file_names = dir.get_files()
		if file_names.size() > 0:
			index = randi_range(0, file_names.size() - 1)
			random_file = file_names[index]
			file_names.remove_at(index)
	
	room.scene_path = layout_dir + random_file
	room.layout = layout
	room.layout_positions = Constants.PLAYER_POSITIONS[layout]


func get_chest_id(pos: Vector2i) -> String:
	var format_string = "dungeon_chest{num}"
	var id = format_string.format({"num": pos})
	
	return id


func _test_create():
	create()
	($MarginContainer/Control as Control).size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	($MarginContainer/Control as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
	%MapTiles.show()
	%MapIcons.show()
	$MarginContainer/Button.show()
	$MarginContainer/Button.disabled = false
	$MarginContainer/Button.pressed.connect(create)
