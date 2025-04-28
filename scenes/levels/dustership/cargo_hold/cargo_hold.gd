extends Level

@onready var elevator = $Elevator
@onready var animation_player = $AnimationPlayer
@onready var entities = $Entities
@onready var elevator_interaction_area = $ElevatorInteraction/InteractionArea


func set_player_position(
	_end_position, active_member_name: Constants.CharacterNames):
	
	const START_POSITION = Vector2(79, 73)
	
	PartyManager.instantiate_party(START_POSITION, active_member_name)
	player = PartyManager.get_active_member()
	
	player.state_machine.transition_to("Hold")
	
	for member in PartyManager.members:
		(member as Player).set_flying(true)
		member.reparent(elevator)
	
	elevator_interaction_area.set_deferred("monitoring", false)
	
	animation_player.play("down")


func down_animation_callback():
	for member in PartyManager.members:
		(member as Player).set_flying(false)
		member.reparent(entities)
	
	player.state_machine.transition_to("Active")
	
	await get_tree().create_timer(2).timeout
	
	elevator_interaction_area.set_deferred("monitoring", true)
