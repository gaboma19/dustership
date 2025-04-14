extends Node2D

var is_keyboard_mouse_controls: bool = false


func _ready():
	$CanvasLayer/RemembrancerCamp.grab_focus()


func _unhandled_input(event: InputEvent):
	# disables PartyManager
	if event.is_action_pressed("switch_character"):
		get_tree().root.set_input_as_handled()
	
	if event is InputEventMouseMotion:
		is_keyboard_mouse_controls = true
	if event is InputEventJoypadMotion:
		if is_keyboard_mouse_controls == true:
			on_joypad_detected()
		is_keyboard_mouse_controls = false


func on_joypad_detected():
	$CanvasLayer/RemembrancerCamp.grab_focus()
