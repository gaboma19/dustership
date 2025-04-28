extends Level

var velocity_component: VelocityComponent

@onready var stairs_interaction_area = $ShipTransitionInteraction/InteractionArea


func set_player_position(
	end_position: Vector2, active_member_name: Constants.CharacterNames):
	
	const START_POSITION = Vector2(-30, 172)
	const STAIRS_POSITION = Vector2(-52, 180)
	
	if end_position == Vector2.INF:
		stairs_interaction_area.set_deferred("monitoring", false)
		
		PartyManager.instantiate_party(START_POSITION, active_member_name)
		player = PartyManager.get_active_member()
		velocity_component = player.velocity_component
		
		player.state_machine.transition_to("Hold")
		player.set_flying(true)
		y_sort_enabled = false
		
		velocity_component.arrived.connect(on_player_arrived_stairs)
		velocity_component.process_accelerate_to_point(STAIRS_POSITION)
	else:
		super(end_position, active_member_name)


func on_player_arrived_stairs():
	const END_POSITION = Vector2(-96, 219)
	
	velocity_component.arrived.disconnect(on_player_arrived_stairs)
	velocity_component.arrived.connect(on_player_arrived_end)
	velocity_component.process_accelerate_to_point(END_POSITION)


func on_player_arrived_end():
	player.state_machine.transition_to("Active")
	player.set_flying(false)
	y_sort_enabled = true
	
	await get_tree().create_timer(2).timeout
	stairs_interaction_area.set_deferred("monitoring", true)
