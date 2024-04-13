extends CanvasLayer


func _physics_process(delta):
	if ParticlesCache.loaded:
		set_physics_process(false)
		open()


func open():
	pass
