extends CanvasLayer


func _ready():
	MusicManager.play_track("heartbeat_of_the_dustership")
	
	SaveManager.capture_and_save_game()
	
	if SaveManager.has_save_data():
		var data = SaveManager.load_game()
		print("has save data" + data)
