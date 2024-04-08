extends Node2D

@onready var game_camera = $GameCamera

@export var is_camera_static: bool = false

var end_screen_scene = preload("res://scenes/ui/end_screen.tscn")
var pause_screen_scene = preload("res://scenes/ui/pause_screen.tscn")


func _ready():
	PlayerVariables.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_screen_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()


func set_player_position(player_position: Vector2):
	PartyManager.instantiate_party(player_position)
	if not is_camera_static:
		game_camera.global_position = player_position
