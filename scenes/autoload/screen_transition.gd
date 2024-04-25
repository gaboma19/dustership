extends CanvasLayer

signal transitioned_halfway

var skip_emit = false


func transition_in():
	$AnimationPlayer.play("transition_in")
	
	
func transition_out():
	$AnimationPlayer.play("transition_out")


func transition_to_level(scene_path: String, player_position: Vector2):	
	var active_member_name = PartyManager.get_active_member().character_name
	
	transition_out()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var level = get_tree().current_scene
	level.set_player_position(player_position, active_member_name)
	
	transition_in()


func restart_game(level_file_path: String):
	PlayerVariables.restart_game()
	
	transition_out()
	
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file.bind(level_file_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	transition_in()
