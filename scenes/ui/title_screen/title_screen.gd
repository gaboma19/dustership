extends CanvasLayer


func _physics_process(delta):
	if MaterialsCache.loaded:
		set_physics_process(false)
		open()


func open():
	pass
