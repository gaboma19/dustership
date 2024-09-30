extends Level

@export var echelon_tiles: Node2D

var number_dead_enemies: int = 0
var total_enemies: int = 0
var chest_scene = preload("res://scenes/entities/chest/chest.tscn")
var reward: InventoryItem
var room: Room


func _ready():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		var health_component = e.get_node("HealthComponent")
		health_component.died.connect(on_enemy_died)
	
	total_enemies = enemies.size()
	map_pin_cell = LevelManager.get_player_dungeon_position()
	
	set_doorways(room)


func set_doorways(room: Room):
	if echelon_tiles == null || room == null:
		return
	
	echelon_tiles.set_doorways(room)


# pastes prickly pear tiles
func set_prickly_pears():
	pass


# open the doorways
# spawn a treasure chest with `reward`
func win():
	print("You win!")


func on_enemy_died():
	number_dead_enemies += 1
	if number_dead_enemies == total_enemies:
		win()
