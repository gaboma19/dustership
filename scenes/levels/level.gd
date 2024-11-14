extends Node2D
class_name Level

@export var is_camera_static = false
@export var map_pin_cell: Vector2i
@export var game_start: Node2D

var end_screen_scene = preload("res://scenes/ui/end_screen/end_screen.tscn")
var pause_screen_scene = preload("res://scenes/ui/pause_screen/pause_screen.tscn")

@onready var game_camera = $GameCamera


func _ready():
	PlayerVariables.died.connect(on_player_died)
	
	HealthBar.show()
	CurrencyCounter.show()
	DungeonManager.show()


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


func set_player_position(
	player_position: Vector2, active_member_name: Constants.CharacterNames):
	
	PartyManager.instantiate_party(player_position, active_member_name)
	
	if not is_camera_static:
		game_camera.global_position = player_position
		game_camera.reset_smoothing()


func set_player_at_game_start(active_member_name: Constants.CharacterNames):
	var player_position = game_start.global_position
	
	PartyManager.instantiate_party(player_position, active_member_name)
	
	if not is_camera_static:
		game_camera.global_position = player_position
		game_camera.reset_smoothing()
