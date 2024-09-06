extends CanvasLayer

@onready var play_button: Button = %PlayButton
@onready var delete_button: Button = %DeleteButton
@onready var back_button: Button = %BackButton
@onready var new_game_button: Button = %NewGameButton
@onready var main_container: VBoxContainer = %MainContainer
@onready var save_slot_container: VBoxContainer = %SaveSlotContainer


func _ready():
	MusicManager.play_track("heartbeat_of_the_dustership")
	
	play_button.pressed.connect(on_play_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	
	if SaveManager.has_save_data():
		new_game_button.text = "Continue"
		delete_button.disabled = false
	else:
		new_game_button.text = "New Game"
		delete_button.disabled = true


func on_play_button_pressed():
	main_container.hide()
	save_slot_container.show()


func on_back_button_pressed():
	save_slot_container.hide()
	main_container.show()
