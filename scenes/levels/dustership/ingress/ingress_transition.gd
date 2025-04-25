extends Node2D

@export var action_name: String

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	interaction_area.action_name = action_name


func on_interact():
	MusicManager.fade_out(10)
	interaction_area.set_deferred("monitoring", false)
	
	var player = PartyManager.get_active_member()
	player.state_machine.transition_to("Hold")
	
	var events = get_tree().get_first_node_in_group("events")
	events.open_portal()
	
	await get_tree().create_timer(4).timeout
	
	ScreenTransition.transition_to_overworld()
