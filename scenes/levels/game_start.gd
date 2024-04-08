extends Node

@export var position: Vector2 = Vector2(32, 56)
@export var enabled: bool = false

@onready var april_scene: PackedScene = preload("res://scenes/entities/player/april.tscn")


func _ready():
	if enabled:
		initialize_april()


func initialize_april():
	var april = april_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(april)
	april.global_position = position
