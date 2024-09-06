extends CanvasLayer

@export var hub_path: String

@onready var play_button: Button = %PlayButton
@onready var delete_button: Button = %DeleteButton
@onready var back_button: Button = %BackButton
@onready var new_game_button: Button = %NewGameButton
@onready var continue_button: Button = %ContinueButton
@onready var main_container: VBoxContainer = %MainContainer
@onready var save_slot_container: VBoxContainer = %SaveSlotContainer


func _ready():
	MusicManager.play_track("heartbeat_of_the_dustership")
	
	play_button.pressed.connect(on_play_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	delete_button.pressed.connect(on_delete_button_pressed)
	new_game_button.pressed.connect(on_new_game_button_pressed)
	continue_button.pressed.connect(on_continue_button_pressed)
	
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
	main_container.show()


func on_delete_button_pressed():
	PopUp.open_decision_container(
		"Are you sure you want to delete your saved game?")
	PopUp.closed.connect(on_pop_up_closed)


func on_pop_up_closed(msg):
	PopUp.closed.disconnect(on_pop_up_closed)
	
	delete_button.grab_focus()
	
	if msg == "Yes":
		SaveManager.delete_game()
		set_save_slot_container()


func on_new_game_button_pressed():
	MusicManager.fade_out(10)
	
	ScreenTransition.transition_to_path(hub_path)


func on_continue_button_pressed():
	MusicManager.fade_out(10)
	
	SaveManager.load_game()
	
	var active_character_name
	if PlayerVariables.is_april_active:
		active_character_name = Constants.CharacterNames.APRIL
	elif PlayerVariables.is_telitz_active:
		active_character_name = Constants.CharacterNames.TELITZ
	
	ScreenTransition.transition_to_level_with_active_member_name(
		hub_path, Vector2(0, -128), active_character_name)
