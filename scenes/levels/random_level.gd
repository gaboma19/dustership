extends Level

var number_dead_enemies: int = 0
var total_enemies: int = 0
var chest_scene = preload("res://scenes/entities/chest/chest.tscn")
var reward: InventoryItem


func _ready():
	map_pin_cell = LevelManager.get_player_map_position()
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	total_enemies = enemies.size()
	
	for e in enemies:
		var health_component = e.get_node("HealthComponent")
		health_component.died.connect(on_enemy_died)


# pastes entrance exit patterns on tilemap
func set_doorways():
	pass


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
