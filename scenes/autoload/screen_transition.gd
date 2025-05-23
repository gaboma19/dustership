extends CanvasLayer

const ANIMATION_LENGTH: float = 0.4

@export var overworld_path: String
@export var main_menu_path: String
@export var ingress_path: String
@export var dustership_map_path: String


func transition_in():
	await get_tree().create_timer(0.3).timeout
	$AnimationPlayer.play("transition_in")


func transition_out():
	$AnimationPlayer.play("transition_out")


func transition_to_level(scene_path: String, player_position: Vector2):
	# store the active party member before transitioning
	var active_member_name = PartyManager.get_active_member().character_name
	# clear the member reference array, but member_scenes is unchanged
	PartyManager.clear_members()
	
	transition_out()
	await get_tree().create_timer(ANIMATION_LENGTH).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	# TODO: https://github.com/godotengine/godot/issues/85852
	await get_tree().process_frame
	await get_tree().process_frame
	
	# re-instantiates the party while keeping the same active party member
	var level = get_tree().current_scene
	level.set_player_position(player_position, active_member_name)
	
	transition_in()


# if the PartyManager is empty, provide active_member_name 
# or use PartyManager.active_member_name to used the saved name
# used in MainMenu, DustershipLocation, Overworld -> ingress
func transition_to_level_with_active_member_name(scene_path: String, 
		player_position: Vector2, active_member_name: Constants.CharacterNames,
		show_animation: bool = true):
	PartyManager.clear_members()
	
	transition_out()
	await get_tree().create_timer(ANIMATION_LENGTH).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var level = get_tree().current_scene
	if show_animation:
		level.set_player_position(player_position, active_member_name)
	else:
		level.set_player_position_without_entrance(player_position, active_member_name)
	
	transition_in()


func transition_to_dungeon_level(scene_path: String, player_position: Vector2, 
		active_member_name: Constants.CharacterNames, room: Room,
		show_animation: bool = true):
	transition_out()
	await get_tree().create_timer(ANIMATION_LENGTH).timeout
	
	PartyManager.clear_members()
	
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	await get_tree().process_frame
	await get_tree().process_frame
	
	var level: DungeonLevel = get_tree().current_scene
	
	if show_animation:
		level.set_player_position(player_position, active_member_name)
	else:
		level.set_player_position_without_entrance(player_position, active_member_name)
	
	level.room = room
	level.build()
	
	DungeonManager.player_dungeon_position = room.map_position
	
	transition_in()


func restart_game(scene_path: String):
	var active_member_name = PartyManager.get_active_member().character_name
	PlayerVariables.restart_game()
	PartyManager.clear_members()
	
	transition_out()
	await get_tree().create_timer(ANIMATION_LENGTH).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var level = get_tree().current_scene
	level.set_player_at_game_start(active_member_name)
	
	transition_in()


# used for UI scenes with no party
func transition_to_path(scene_path: String):
	transition_out()
	await get_tree().create_timer(ANIMATION_LENGTH).timeout
	get_tree().change_scene_to_file.bind(scene_path).call_deferred()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	transition_in()


func transition_to_overworld():
	DungeonManager.exit()
	transition_to_path(overworld_path)


func transition_to_ingress():
	const INGRESS_PLAYER_POSITION = Vector2(7, 123)
	
	transition_to_level_with_active_member_name(
		ingress_path, INGRESS_PLAYER_POSITION, PartyManager.active_member_name, false)


func transition_to_dustership_map():
	PartyManager.clear_members()
	
	transition_to_path(dustership_map_path)


func transition_to_main_menu():
	transition_to_path(main_menu_path)
