extends Node2D

const OVERWORLD_PLAYER_SCENE = preload(
	"res://scenes/overworld/tiles/overworld_player.tscn")

@onready var active_layer = $EchelonLayer1


func _ready():
	initialize_player()
	
	HealthBar.hide()
	SteelCounter.hide()


func initialize_player():
	var player = OVERWORLD_PLAYER_SCENE.instantiate()
	add_child(player)
	
	var player_position = active_layer.map_to_global(
		OverworldVariables.player_map_position)
	player.global_position = player_position
	
	player.active_layer = active_layer
