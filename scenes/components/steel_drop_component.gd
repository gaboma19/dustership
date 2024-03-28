extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: Node

var steel_scene = preload("res://scenes/entities/steel/steel.tscn")


func _ready():
	(health_component as HealthComponent).died.connect(on_died)
	
	
func on_died():
	if steel_scene == null:
		return
		
	if not owner is Node2D:
		return
	
	if randf() > drop_percent:
		return
		
	var spawn_position = (owner as Node2D).global_position
	var steel_instance = steel_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(steel_instance)
	steel_instance.global_position = spawn_position
