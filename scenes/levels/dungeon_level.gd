extends Level
class_name DungeonLevel

@export var echelon_tiles: Node2D
@export var dungeon_level_transition_areas_controller: Node2D
@export var echelon_obstacle_tiles: TileMapLayer
@export var entrance_scene: PackedScene
@export var exit_scene: PackedScene
@export var spawner: Node

var room: Room

@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	spawner.enemies_cleared.connect(win)
	
	HUD.show()
	DungeonManager.show()
	
	set_entrance_points()
	
	#_test_set_doorways()
	#_test_spawn_chest(1.0)
	#_test_spawn_enemies(4.0)
	#_test_close_doors(1.0)


func set_entrance_points():
	var transition_areas = get_tree().get_nodes_in_group("transition_area")
	for area in transition_areas:
		var node = area.get_child(0)
		var node2d = node as Node2D
		entrance_points.append(node2d)


func build():
	if echelon_tiles == null or room == null:
		return
	
	set_doorways()
	
	match room.type:
		Room.Type.ENTRANCE:
			room.visited = true
			var entrance = entrance_scene.instantiate()
			entities_layer.add_child(entrance)
		Room.Type.EXIT:
			room.visited = true
			var exit = exit_scene.instantiate()
			entities_layer.add_child(exit)
		Room.Type.DEFAULT:
			if not room.visited:
				spawner.spawn_enemies()
				await get_tree().create_timer(0.4).timeout #TODO: wait for obstacles
				echelon_obstacle_tiles.close_doors()
	
	spawner.build(room)


func set_doorways():
	for direction in room.neighbors.keys():
		if room.neighbors[direction] != null:
			echelon_tiles.paste_doorway(direction)
			dungeon_level_transition_areas_controller.set_transition_area_scene_path(
				room.neighbors[direction], direction)
			echelon_obstacle_tiles.paste_doorway(direction)


func win():
	room.visited = true
	echelon_obstacle_tiles.open_doors()
	spawner.spawn_chest()


func _mock_room():
	var test_room: Room = Room.new()
	test_room.neighbors = {
		Vector2i.UP: Room.new(),
		Vector2i.DOWN: Room.new(),
		Vector2i.LEFT: Room.new(),
		Vector2i.RIGHT: Room.new()
	}
	test_room.layout_positions = Constants.PLAYER_POSITIONS[Room.Layout.B]
	for neighbor in test_room.neighbors.values():
		neighbor.layout_positions = Constants.PLAYER_POSITIONS[Room.Layout.B]
	room = test_room


func _test_set_doorways():
	_mock_room()
	
	set_doorways()


func _test_spawn_chest(delay: float):
	await get_tree().create_timer(delay).timeout
	spawner.spawn_chest()


func _test_spawn_enemies(delay: float):
	_mock_room()
	
	await get_tree().create_timer(delay).timeout
	spawner.spawn_enemies()


func _test_close_doors(delay: float):
	await get_tree().create_timer(delay).timeout
	
	echelon_obstacle_tiles.close_doors()
