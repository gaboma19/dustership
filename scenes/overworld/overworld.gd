extends Node2D

@export var overworld_player_scene: PackedScene

var player: OverworldPlayer

@onready var overworld_stack = $OverworldStack


func _ready():
	var active_layer = get_tree().get_first_node_in_group("layers")
	OverworldVariables.active_layer = active_layer
	
	initialize_player()
	active_layer.layer_changed.connect(on_layer_changed)
	
	HealthBar.hide()
	SteelCounter.hide()
	DungeonManager.hide()


func initialize_player():
	player = overworld_player_scene.instantiate()
	add_child(player)
	
	var active_layer = OverworldVariables.active_layer
	var player_position = active_layer.map_to_global(
		OverworldVariables.player_map_position)
	player.global_position = player_position


func switch_layers(next_layer_scene: PackedScene):
	player.exit()
	OverworldVariables.active_layer.exit()
	await OverworldVariables.active_layer.tree_exited
	
	overworld_stack.move_up()
	await get_tree().create_timer(1.0).timeout
	
	var next_layer = next_layer_scene.instantiate()
	next_layer.set_modulate(Color.TRANSPARENT)
	OverworldVariables.active_layer = next_layer
	next_layer.layer_changed.connect(on_layer_changed)
	add_child(next_layer)
	
	next_layer.enter()
	await get_tree().create_timer(2.0).timeout
	
	overworld_stack.reset()
	initialize_player()


func on_layer_changed(next_layer_scene: PackedScene):
	switch_layers(next_layer_scene)
