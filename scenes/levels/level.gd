extends Node2D

@onready var player: Player = %Player
@onready var game_camera = $GameCamera

@export var end_screen_scene: PackedScene

var pause_screen_scene = preload("res://scenes/ui/pause_screen.tscn")


func _ready():
	player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_screen_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()


func set_player_position(player_position: Vector2):
	player.global_position = player_position
	game_camera.global_position = player_position
