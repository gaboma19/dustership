extends Node

var save_path = "user://save_game.save"


func save_game(data: SaveData):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()
	print("Game saved!")


func load_game() -> SaveData:
	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = file.get_var()
	file.close()
	print("Game loaded!")
	return data
