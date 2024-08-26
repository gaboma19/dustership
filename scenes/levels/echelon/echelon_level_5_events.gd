extends Node

const PHILO_SCENE = preload("res://scenes/entities/enemies/philo/philo.tscn")

var spawn_points: Array[Node]

@onready var chest = %Chest
@onready var spawn_points_parent = $SpawnPointsParent
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	MusicManager.play_track("heartbeat_of_the_dustership")
	chest.opened.connect(on_chest_opened)
	
	spawn_points = spawn_points_parent.get_children()


func spawn_enemies():
	for point in spawn_points:
		var philo = PHILO_SCENE.instantiate()
		entities_layer.call_deferred("add_child", philo)
		philo.global_position = point.global_position


func on_chest_opened():
	# player.speak(LINES)
	pass
