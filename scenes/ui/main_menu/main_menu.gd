extends CanvasLayer

@export var first_path: String

@onready var play_button: Button = %PlayButton
@onready var delete_button: Button = %DeleteButton
@onready var save_back_button: Button = %SaveBackButton
@onready var new_game_button: Button = %NewGameButton
@onready var continue_button: Button = %ContinueButton
@onready var credits_button: Button = %CreditsButton
@onready var credits_back_button: Button = %CreditsBackButton
@onready var quit_button: Button = %QuitButton
@onready var settings_button: Button = %SettingsButton
@onready var settings_back_button: Button = %SettingsBackButton
@onready var next_button: Button = %NextButton
@onready var main_container: VBoxContainer = %MainContainer
@onready var save_slot_container: VBoxContainer = %SaveSlotContainer
@onready var credits_container: VBoxContainer = %CreditsContainer
@onready var settings_container: VBoxContainer = %SettingsContainer


func _ready():
	MusicManager.fade_out_to("heartbeat_of_the_dustership")
	
	play_button.pressed.connect(on_play_button_pressed)
	save_back_button.pressed.connect(on_back_button_pressed)
	delete_button.pressed.connect(on_delete_button_pressed)
	new_game_button.pressed.connect(on_new_game_button_pressed)
	continue_button.pressed.connect(on_continue_button_pressed)
	credits_button.pressed.connect(on_credits_button_pressed)
	credits_back_button.pressed.connect(on_back_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	settings_button.pressed.connect(on_settings_button_pressed)
	settings_back_button.pressed.connect(on_back_button_pressed)
	next_button.pressed.connect(on_next_button_pressed)
	
	set_save_slot_container()
	
	play_button.grab_focus()


func set_save_slot_container():
	var has_save_data: bool = SaveManager.has_save_data()
	
	new_game_button.visible = not has_save_data
	new_game_button.disabled = has_save_data
	
	continue_button.visible = has_save_data
	continue_button.disabled = not has_save_data
	
	delete_button.disabled = not has_save_data


func on_play_button_pressed():
	main_container.hide()
	save_slot_container.show()
	
	if SaveManager.has_save_data():
		continue_button.grab_focus()
	else:
		new_game_button.grab_focus()


func on_back_button_pressed():
	save_slot_container.hide()
	credits_container.hide()
	settings_container.hide()
	main_container.show()
	play_button.grab_focus()


func on_delete_button_pressed():
	PopUp.open_decision_container(
		"Are you sure you want to delete your saved game?")
	PopUp.closed.connect(on_delete_pop_up_closed)


func on_delete_pop_up_closed(msg):
	PopUp.closed.disconnect(on_delete_pop_up_closed)
	
	delete_button.grab_focus()
	
	if msg == "Yes":
		SaveManager.delete_game()
		set_save_slot_container()


func on_new_game_button_pressed():
	MusicManager.fade_out(10)
	
	ScreenTransition.transition_to_path(first_path)


func on_continue_button_pressed():
	MusicManager.fade_out(10)
	
	SaveManager.load_game()
	
	var active_character_name
	if PlayerVariables.is_april_active:
		active_character_name = Constants.CharacterNames.APRIL
	elif PlayerVariables.is_telitz_active:
		active_character_name = Constants.CharacterNames.TELITZ
	
	ScreenTransition.transition_to_level_with_active_member_name(
		first_path, Vector2(7, 136), active_character_name)


func on_credits_button_pressed():
	main_container.hide()
	credits_container.show()
	
	credits_back_button.grab_focus()


func on_next_button_pressed():
	var panel1 = $"Margin Container/VBoxContainer/CreditsContainer/Panel1"
	var panel2 = $"Margin Container/VBoxContainer/CreditsContainer/Panel2"
	
	panel1.visible = not panel1.visible
	panel2.visible = not panel2.visible


func on_quit_button_pressed():
	PopUp.open_decision_container(
		"Are you sure you want to quit?", true)
	PopUp.closed.connect(on_quit_pop_up_closed)


func on_quit_pop_up_closed(msg):
	PopUp.closed.disconnect(on_quit_pop_up_closed)
	
	quit_button.grab_focus()
	
	if msg == "Yes":
		get_tree().quit()


func on_settings_button_pressed():
	main_container.hide()
	settings_container.show()
	
	settings_back_button.grab_focus()
