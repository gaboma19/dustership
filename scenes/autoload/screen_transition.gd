extends CanvasLayer

@export var overworld_path: String


func transition_in():
	$AnimationPlayer.play("transition_in")


func transition_out():
	$AnimationPlayer.play("transition_out")


func transition_to_level(scene_path: String, player_position: Vector2):
	# store the active party member before transitioning
	var active_member_name = PartyManager.get_active_member().character_name
	# clear the member reference array, but member_scenes is unchanged
	PartyManager.clear_members()
	
	transition_out()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	# re-instantiates the party while keeping the same active party member
	var level = get_tree().current_scene
	level.set_player_position(player_position, active_member_name)
	
	transition_in()


func transition_to_level_from_overworld(
	scene_path: String, player_position: Vector2, active_member_name: Constants.CharacterNames):
	PartyManager.clear_members()
	
	transition_out()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var level = get_tree().current_scene
	level.set_player_position(player_position, active_member_name)
	
	transition_in()


func restart_game(scene_path: String):
	var active_member_name = PartyManager.get_active_member().character_name
	PlayerVariables.restart_game()
	PartyManager.clear_members()
	
	transition_out()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var level = get_tree().current_scene
	level.set_player_at_game_start(active_member_name)
	
	transition_in()


func transition_to_overworld():
	transition_out()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file.bind(overworld_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	transition_in()
