extends CanvasLayer

@onready var title = $Center/Title


func _ready():
	MusicManager.play_track("fanfare")


func _unhandled_input(event):
	if event.is_pressed():
		get_tree().root.set_input_as_handled()
		continue_to_main_menu()


func dissolve_title():
	var tween = create_tween()
	tween.tween_property(title.material, "shader_parameter/dissolve_value", 0, 0)
	tween.tween_property(title.material, "shader_parameter/dissolve_value", 1.0, 0.5)


func continue_to_main_menu():
	ScreenTransition.transition_to_main_menu()
