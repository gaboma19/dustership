extends Node2D


func _unhandled_input(event):
	# disables PartyManager
	if event.is_action_pressed("switch_character"):
		get_tree().root.set_input_as_handled()
