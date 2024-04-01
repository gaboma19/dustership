extends CanvasLayer

signal transitioned_halfway

var skip_emit = false


func transition_in():
	$AnimationPlayer.play("transition_in")
	
	
func transition_out():
	$AnimationPlayer.play("transition_out")


func transition_to_scene(scene_path: String):
	transition_out()

	get_tree().change_scene_to_file(scene_path)
	
	await get_tree().process_frame
	transition_in()
	
	
func transition_to_level(scene_path: String, player_position: Vector2):
	transition_out()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var level = get_tree().current_scene
	level.set_player_position(player_position)
	
	transition_in()
