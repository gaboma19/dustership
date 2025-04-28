extends Node2D

@export var path: String

@onready var interaction_area = $InteractionArea
@onready var animation_player = $"../AnimationPlayer"
@onready var elevator = $"../Elevator"


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	interaction_area.set_deferred("monitoring", false)
	
	MusicManager.fade_out(10)
	
	var player: Player = PartyManager.get_active_member()
	
	player.state_machine.transition_to("Hold")
	player.position = position
	
	for member in PartyManager.members:
		(member as Player).set_flying(true)
		member.reparent(elevator)
	
	animation_player.play("up")


func up_animation_callback():
	ScreenTransition.transition_to_level(path, Vector2.INF)
