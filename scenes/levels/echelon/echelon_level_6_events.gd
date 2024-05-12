extends Node

const IDENTITY_CORE_LEFT = preload(
	"res://resources/inventory_item/items/identity_core_left.tres")

var number_raster_groups: int = 0
var number_dead_enemies: int = 0
var number_spawned_enemies: int = 0
var is_done_spawning: bool = false
var philo_spawn_points: Array[Node]
var raster_spawn_points: Array[Node]
var philo_scene = preload("res://scenes/entities/enemies/philo/philo.tscn")
var raster_scene = preload("res://scenes/entities/enemies/raster/raster.tscn")
var chest_scene = preload("res://scenes/entities/chest/chest.tscn")

@onready var spawn_points_parent = $SpawnPointsParent
@onready var entities_layer = get_tree().get_first_node_in_group("entities")


func _ready():
	set_philo_spawn_points()
	set_raster_spawn_points()
	$PhiloTimer.timeout.connect(on_philo_timer_timeout)
	$RasterTimer.timeout.connect(on_raster_timer_timeout)
	%BossDoor.triggered.connect(on_boss_door_triggered)


func spawn_philo_group():
	var point = philo_spawn_points.pop_front()
	if philo_spawn_points.is_empty():
		set_philo_spawn_points()
	for n in 4:
		number_spawned_enemies += 1
		
		var philo = philo_scene.instantiate()
		entities_layer.add_child(philo)
		
		var point_offset = Vector2.RIGHT.rotated(PI / 2 * n) * 24
		philo.global_position = point.global_position + point_offset
		
		var health_component = philo.get_node("HealthComponent")
		health_component.died.connect(on_enemy_died)
		
		var state_machine = philo.get_node("StateMachine")
		state_machine.transition_to("Spawn")


func spawn_raster_group():
	number_raster_groups += 1
	var wave_size = min(number_raster_groups, 2)
	
	if number_raster_groups == 2:
		$RasterTimer.wait_time *= 2
	
	if number_raster_groups == 4:
		$PhiloTimer.stop()
		$RasterTimer.stop()
		is_done_spawning = true

	for n in wave_size:
		number_spawned_enemies += 1
		var point = raster_spawn_points.pop_front()
		if raster_spawn_points.is_empty():
			set_raster_spawn_points()
		var raster = raster_scene.instantiate()
		entities_layer.add_child(raster)
		raster.global_position = point.global_position
		
		var health_component = raster.get_node("HealthComponent")
		health_component.died.connect(on_enemy_died)
		
		var state_machine = raster.get_node("StateMachine")
		state_machine.transition_to("Spawn")


func set_philo_spawn_points():
	philo_spawn_points = spawn_points_parent.get_children()
	philo_spawn_points.shuffle()


func set_raster_spawn_points():
	raster_spawn_points = spawn_points_parent.get_children()
	raster_spawn_points.shuffle()


func end_boss():
	%BossDoor.open()
	var chest = chest_scene.instantiate()
	chest.inventory_item = IDENTITY_CORE_LEFT
	chest.chest_id = "echelon6_chest0"
	entities_layer.add_child(chest)
	chest.global_position = $ChestSpawn.global_position
	chest.spawn()


func on_philo_timer_timeout():
	spawn_philo_group()


func on_raster_timer_timeout():
	spawn_raster_group()


func on_enemy_died():
	number_dead_enemies += 1
	
	if is_done_spawning && (
		number_dead_enemies == number_spawned_enemies || 
		number_dead_enemies > number_spawned_enemies):
		end_boss()


func on_boss_door_triggered():
	$PhiloTimer.start()
	$RasterTimer.start()
	spawn_philo_group()
	spawn_philo_group()
	spawn_philo_group()
