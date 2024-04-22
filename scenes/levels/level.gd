extends Node2D

@export var is_camera_static: bool = false
@export var map_pin_cell: Vector2i

var end_screen_scene = preload("res://scenes/ui/end_screen/end_screen.tscn")
var pause_screen_scene = preload("res://scenes/ui/pause_screen/pause_screen.tscn")

@onready var game_camera = $GameCamera


func _ready():
	PlayerVariables.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()
		var pause_screen = pause_screen_scene.instantiate()
		pause_screen.map_pin_cell = map_pin_cell
		add_child(pause_screen)


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.level_file_path = scene_file_path
	end_screen_instance.set_defeat()


func set_player_position(player_position: Vector2):
	if PlayerVariables.enable_game_start:
		return
	
	PartyManager.instantiate_party(player_position)
	if not is_camera_static:
		game_camera.global_position = player_position
