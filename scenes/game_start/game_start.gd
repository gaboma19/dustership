extends Node2D

const APRIL_SCENE: PackedScene = preload("res://scenes/entities/players/april/april.tscn")
const CUBE_SCENE: PackedScene = preload("res://scenes/entities/players/cube/cube.tscn")
const TELITZ_SCENE: PackedScene = preload("res://scenes/entities/players/telitz/telitz.tscn")

@export var enabled: bool = PlayerVariables.enable_game_start


func _ready():
	if OS.has_feature("editor"):
		PlayerVariables.has_sword = true
		PlayerVariables.has_gun = true
		#Inventory.add_item(preload("res://resources/inventory_item/items/identity_core.tres"))
		#Inventory.add_item(preload("res://resources/inventory_item/items/eremite_diskette.tres"))
		#EntityVariables.conversations["intro_cutscene"] = { "interacted": true }
	
	if enabled:
		# happens only once at the beginning of the game
		PlayerVariables.enable_game_start = false
		initialize_april()
		
		if OS.has_feature("editor"):
			pass
			#initialize_telitz()
			#initialize_cube()


func initialize_april():
	if PartyManager.has_member(Constants.CharacterNames.APRIL):
		return
	
	var april = APRIL_SCENE.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(april)
	april.global_position = global_position


func initialize_cube():
	if PartyManager.has_member(Constants.CharacterNames.CUBE):
		return
	
	var cube = CUBE_SCENE.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(cube)
	cube.global_position = global_position


func initialize_telitz():
	if PartyManager.has_member(Constants.CharacterNames.TELITZ):
		return
	
	var telitz = TELITZ_SCENE.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities")
	entities_layer.add_child(telitz)
	telitz.global_position = global_position
