extends Level

@export var echelon_tiles: Node2D
@export var dungeon_level_transition_areas_controller: Node2D
@export var echelon_obstacle_tiles: TileMapLayer
@export var entrance_scene: PackedScene
@export var exit_scene: PackedScene
@export var spawner: Node

var reward: InventoryItem
var room: Room

@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	spawner.enemies_cleared.connect(win)
	
	HealthBar.show()
	SteelCounter.show()
	DungeonManager.show()
	
	#_test_set_doorways()
	#_test_spawn_chest(4.0)
	#_test_spawn_enemies(4.0)
	_test_close_doors(1.0)


### called by ScreenTransition.transition_to_dungeon_level()
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
	spawner.spawn_chest(reward)


func _mock_room():
	var test_room: Room = Room.new()
	test_room.neighbors = {
		Vector2i.UP: Room.new(),
		Vector2i.DOWN: Room.new(),
		Vector2i.LEFT: Room.new(),
		Vector2i.RIGHT: Room.new()
	}
	room = test_room


func _test_set_doorways():
	_mock_room()
	
	set_doorways()


func _test_spawn_chest(delay: float):
	await get_tree().create_timer(delay).timeout
	spawner.spawn_chest(reward)


func _test_spawn_enemies(delay: float):
	_mock_room()
	
	await get_tree().create_timer(delay).timeout
	spawner.spawn_enemies()


func _test_close_doors(delay: float):
	await get_tree().create_timer(delay).timeout
	
	echelon_obstacle_tiles.close_doors()
