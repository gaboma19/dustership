extends Node2D

@export var enabled: bool = PlayerVariables.enable_game_start

@onready var april_scene: PackedScene = preload("res://scenes/entities/player/april.tscn")


func _ready():
	if enabled:
		PlayerVariables.enable_game_start = false
		initialize_april()


func initialize_april():
	var april = april_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(april)
	april.global_position = global_position
