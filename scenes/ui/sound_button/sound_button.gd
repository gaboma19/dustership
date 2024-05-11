extends Button

@onready var audio_stream_player = $RandomAudioStreamPlayer2D


func _ready():
	pressed.connect(on_pressed)
	
	
func on_pressed():
	audio_stream_player.play_random()
