extends Node2D

@onready var player: Player = %Player
@onready var game_camera = $GameCamera

@export var end_screen_scene: PackedScene


func _ready():
	player.health_component.died.connect(on_player_died)


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()


func set_player_position(player_position: Vector2):
	player.global_position = player_position
	game_camera.global_position = player_position
