extends CanvasLayer

@onready var title = $Center/Title


func _physics_process(_delta):
	if MaterialsCache.loaded:
		set_physics_process(false)
		open()


func _unhandled_input(event):
	if event.is_action_type():
		get_tree().root.set_input_as_handled()
		continue_to_main_menu()


func dissolve_title():
	var tween = create_tween()
	tween.tween_property(title.material, "shader_parameter/dissolve_value", 0, 0)
	tween.tween_property(title.material, "shader_parameter/dissolve_value", 1.0, 0.5)


func continue_to_main_menu():
	MusicManager.fade_out(5.0)
	hide()
	print("continue to main menu")


func open():
	MusicManager.play_track("fanfare")
