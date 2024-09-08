extends MarginContainer

@export var main_menu_path: String

@onready var save_button: Button = %SaveButton
@onready var settings_button: Button = %SettingsButton
@onready var main_menu_button: Button = %MainMenuButton


func _ready():
	save_button.pressed.connect(on_save_button_pressed)
	settings_button.pressed.connect(on_settings_button_pressed)
	main_menu_button.pressed.connect(on_main_menu_button_pressed)

	save_button.disabled = false
	save_button.grab_focus()


func on_save_button_pressed():
	SaveManager.save_game()
	save_button.text = "Saved"
	save_button.disabled = true
	settings_button.grab_focus()


func on_settings_button_pressed():
	pass


func on_main_menu_button_pressed():
	PopUp.open_decision_container("Are you sure you want to quit?")
	PopUp.closed.connect(on_main_menu_pop_up_closed)


func on_main_menu_pop_up_closed(msg):
	PopUp.closed.disconnect(on_main_menu_pop_up_closed)
	
	main_menu_button.grab_focus()
	
	if msg == "Yes":
		ScreenTransition.transition_to_path(main_menu_path)
