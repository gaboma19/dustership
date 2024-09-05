extends Node

const SAVE_PATH = "user://save_game.save"


func save_game():
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		pass





#func save_game(data: SaveData):
	#var file = FileAccess.open(save_path, FileAccess.WRITE)
	#file.store_var(data)
	#file.close()
#
#
#func capture_save_data() -> SaveData:
	#var data = SaveData.new()
	#
	#data.items = Inventory.items
	#
	#data.active_layer = OverworldVariables.active_layer
	#data.player_map_position = OverworldVariables.player_map_position
	#data.ingresses = OverworldVariables.ingresses
	#
	#data.member_scenes = PartyManager.member_scenes
	#
	#data.current_health = PlayerVariables.current_health
	#data.max_health = PlayerVariables.max_health
	#data.steel = PlayerVariables.steel
	#data.pause_menu_screen = PlayerVariables.pause_menu_screen
	#data.has_sword = PlayerVariables.has_sword
	#data.has_gun = PlayerVariables.has_gun
	#
	#return data
#
#
#func capture_and_save_game():
	#var data = capture_save_data()
	#save_game(data)
#
#
#func load_game() -> SaveData:
	#var file = FileAccess.open(save_path, FileAccess.READ)
	#var encoded_object: EncodedObjectAsID = file.get_var()
	#var id = encoded_object.get_instance_id()
	#var data = instance_from_id(id)
	#file.close()
	#
	#return data
#
#
#func has_save_data() -> bool:
	#return FileAccess.file_exists(save_path)
