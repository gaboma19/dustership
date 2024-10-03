extends LevelTransitionArea

var neighbor: Room


func on_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	MusicManager.fade_out(10)
	set_deferred("monitoring", false)
	
	var active_member_name = player.character_name
	
	ScreenTransition.transition_to_dungeon_level(
		path, new_player_position, active_member_name, neighbor)
