extends CanvasLayer


func _ready():
	MusicManager.play_track("heartbeat_of_the_dustership")
	
	if SaveManager.has_save_data():
		var data = SaveManager.load_game()
		print(data)
