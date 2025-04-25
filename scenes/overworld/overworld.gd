extends Node2D

@export var overworld_player_scene: PackedScene

var player: OverworldPlayer

@onready var overworld_stack = $Background/OverworldStack
@onready var return_to_ship_button = %ReturnToShipButton
@onready var active_plane = get_tree().get_first_node_in_group("planes")


func _ready():
	OverworldVariables.active_plane = active_plane
	
	initialize_player()
	
	active_plane.plane_changed.connect(on_plane_changed)
	return_to_ship_button.pressed.connect(on_return_button_pressed)
	
	HUD.hide()
	DungeonManager.hide()


func _unhandled_input(event):
	# disables PartyManager
	if event.is_action_pressed("switch_character"):
		get_tree().root.set_input_as_handled()


func initialize_player():
	player = overworld_player_scene.instantiate()
	add_child(player)
	
	var player_position = active_plane.map_to_global(
		OverworldVariables.player_map_position)
	player.global_position = player_position
	player.reset_indicator_tile()


func switch_planes(next_plane_scene: PackedScene):
	player.exit()
	OverworldVariables.active_plane.exit()
	await OverworldVariables.active_plane.tree_exited
	
	overworld_stack.move_up()
	await get_tree().create_timer(1.0).timeout
	
	var next_plane = next_plane_scene.instantiate()
	next_plane.set_modulate(Color.TRANSPARENT)
	OverworldVariables.active_plane = next_plane
	next_plane.plane_changed.connect(on_plane_changed)
	add_child(next_plane)
	
	next_plane.enter()
	await get_tree().create_timer(2.0).timeout
	
	overworld_stack.reset()
	initialize_player()


func on_plane_changed(next_plane_scene: PackedScene):
	switch_planes(next_plane_scene)


func on_return_button_pressed():
	PopUp.open_decision_container("Exit the Echelon?")
	PopUp.closed.connect(on_popup_closed)


func on_popup_closed(msg):
	PopUp.closed.disconnect(on_popup_closed)
	
	if msg == "Yes":
		ScreenTransition.transition_to_ingress()
