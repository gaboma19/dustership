extends Level

@export var echelon_tiles: Node2D
@export var dungeon_level_transition_areas_controller: Node2D
@export var entrance_scene: PackedScene
@export var exit_scene: PackedScene

var number_dead_enemies: int = 0
var total_enemies: int = 0
var chest_scene = preload("res://scenes/entities/chest/chest.tscn")
var reward: InventoryItem
var room: Room

@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		var health_component = e.get_node("HealthComponent")
		health_component.died.connect(on_enemy_died)
	
	total_enemies = enemies.size()
	
	HealthBar.show()
	SteelCounter.show()
	DungeonManager.show()
	
	#_test_set_doorways()


func build():
	if echelon_tiles == null || room == null:
		return
	
	echelon_tiles.set_doorways(room)
	dungeon_level_transition_areas_controller.set_doorways(room)
	
	match room.type:
		Room.Type.ENTRANCE:
			var entrance = entrance_scene.instantiate()
			entities_layer.add_child(entrance)
		Room.Type.EXIT:
			var exit = exit_scene.instantiate()
			entities_layer.add_child(exit)
		Room.Type.DEFAULT:
			paste_prickly_pears()


func paste_prickly_pears():
	pass


## open the doorways
## spawn a treasure chest with `reward`
func win():
	print("You win!")


func on_enemy_died():
	number_dead_enemies += 1
	if number_dead_enemies == total_enemies:
		win()


func _test_set_doorways():
	var test_room: Room = Room.new()
	test_room.neighbors = {
		Vector2i.UP: Room.new(),
		Vector2i.DOWN: Room.new(),
		Vector2i.LEFT: Room.new(),
		Vector2i.RIGHT: Room.new()
	}
	
	echelon_tiles.set_doorways(test_room)
