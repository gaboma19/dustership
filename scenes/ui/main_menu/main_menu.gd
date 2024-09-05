extends CanvasLayer


func _ready():
	MusicManager.play_track("heartbeat_of_the_dustership")
	
	SaveManager.load_game()
