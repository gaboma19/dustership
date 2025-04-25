extends Node2D

@export var path: String
@export var new_player_position: Vector2

var player: Player
var velocity_component: VelocityComponent

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	const STAIRS_POSITION = Vector2(-52, 180)
	
	interaction_area.set_deferred("monitoring", false)
	
	MusicManager.fade_out(10)
	
	player = PartyManager.get_active_member()
	player.state_machine.transition_to("Hold")
	player.global_position = Vector2(-93, 215)
	player.set_flying(true)
	$"..".y_sort_enabled = false
	velocity_component = player.velocity_component
	velocity_component.arrived.connect(on_player_arrived_stairs)
	velocity_component.process_accelerate_to_point(STAIRS_POSITION)


func on_player_arrived_stairs():
	const STAIRS_POSITION = Vector2(-30, 172)
	
	velocity_component.arrived.disconnect(on_player_arrived_stairs)
	velocity_component.arrived.connect(on_player_arrived_door)
	velocity_component.process_accelerate_to_point(STAIRS_POSITION)


func on_player_arrived_door():
	ScreenTransition.transition_to_level(path, new_player_position)
