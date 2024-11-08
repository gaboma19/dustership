extends Node

@export var number: int
@export var health_component: Node
@export var byte_scene: PackedScene


func _ready():
	(health_component as HealthComponent).died.connect(on_died)


func spawn_byte():
	var spawn_position = (owner as Node2D).global_position
	var byte_instance = byte_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(byte_instance)
	byte_instance.global_position = spawn_position


func on_died():
	if byte_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	for n in number:
		spawn_byte()
