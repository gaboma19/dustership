extends Node


func short():
	Engine.time_scale = 0
	await get_tree().create_timer(0.15, true, false, true).timeout
	Engine.time_scale = 1


func slow_motion_short():
	Engine.time_scale = 0.75
	await get_tree().create_timer(0.15, true, false, true).timeout
	Engine.time_scale = 1
