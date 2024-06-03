extends Area2D

@export var obstacles_parent: Node2D
@export var enemies_parent: Node

var number_enemies: int = 0
var number_dead_enemies: int = 0
var obstacles: Array[Node]
var enemies: Array[Node]


func _ready():
	body_entered.connect(on_body_entered)
	
	obstacles_parent.y_sort_enabled = true
	obstacles = obstacles_parent.get_children()
	enemies = enemies_parent.get_children()
	
	number_enemies = enemies.size()
	for enemy: Enemy in enemies:
		var health_component: HealthComponent
		health_component = enemy.get_node("HealthComponent")
		health_component.died.connect(on_enemy_died)


func raise_obstacles():
	for obstacle: Obstacle in obstacles:
		obstacle.rise()


func lower_obstacles():
	for obstacle: Obstacle in obstacles:
		obstacle.lower()


func on_body_entered(_player: Player):
	set_deferred("monitoring", false)
	raise_obstacles()


func on_enemy_died():
	number_dead_enemies += 1
	
	if number_dead_enemies >= number_enemies:
		lower_obstacles()
