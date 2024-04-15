extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: Node

var heart_pickup_scene = preload("res://scenes/entities/heart_pickup/heart_pickup.tscn")


func _ready():
	(health_component as HealthComponent).died.connect(on_died)
	
	
func on_died():
	if heart_pickup_scene == null:
		return
		
	if not owner is Node2D:
		return
	
	if randf() > drop_percent:
		return
		
	var spawn_position = (owner as Node2D).global_position
	var heart_pickup_instance = heart_pickup_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(heart_pickup_instance)
	heart_pickup_instance.global_position = spawn_position
