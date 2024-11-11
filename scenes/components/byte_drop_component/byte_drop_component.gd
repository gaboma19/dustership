extends Node

@export var number: int
@export var health_component: Node
@export var byte_scene: PackedScene


func _ready():
	(health_component as HealthComponent).died.connect(on_died)


func spawn_byte(angle: float):
	var spawn_position = (owner as Node2D).global_position
	var byte = byte_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	byte.angle = angle
	entities_layer.add_child(byte)
	
	
	byte.global_position = spawn_position


func on_died():
	if byte_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var mod: int = randi_range(-2, 2)
	number += mod
	
	var angle: float = (1.0 / number) * TAU
	
	for n in number:
		spawn_byte(angle * n)
