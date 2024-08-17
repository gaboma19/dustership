extends Node2D

const OVERWORLD_PLAYER_SCENE = preload(
	"res://scenes/overworld/tiles/overworld_player.tscn")

@onready var active_map = $OverworldTileMap


func _ready():
	initialize_player()


func initialize_player():
	var player = OVERWORLD_PLAYER_SCENE.instantiate()
	add_child(player)
	
	var player_position = active_map.map_to_global(
		OverworldVariables.player_map_position)
	player.global_position = player_position
	
	player.active_map = active_map
