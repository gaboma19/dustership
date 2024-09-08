extends MarginContainer

@onready var save_button: Button = %SaveButton
@onready var settings_button: Button = %SettingsButton
@onready var main_menu_button: Button = %MainMenuButton


func _ready():
	save_button.pressed.connect(on_save_button_pressed)
	save_button.disabled = false
	
	save_button.grab_focus()


func on_save_button_pressed():
	SaveManager.save_game()
	save_button.text = "Game saved"
	save_button.disabled = true
	settings_button.grab_focus()
