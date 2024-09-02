extends CanvasLayer


func _physics_process(_delta):
	if MaterialsCache.loaded:
		set_physics_process(false)
		open()


func _unhandled_input(event):
	if event.is_action_type():
		get_tree().root.set_input_as_handled()
		continue_to_main_menu()


func continue_to_main_menu():
	MusicManager.fade_out(5.0)
	hide()
	print("continue to main menu")


func open():
	MusicManager.play_track("fanfare")
