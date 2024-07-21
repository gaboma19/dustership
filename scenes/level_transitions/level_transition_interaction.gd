extends Node2D

@export var path: String
@export var new_player_position: Vector2

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	interaction_area.set_deferred("monitoring", false)
	
	MusicManager.fade_out(10)
	
	ScreenTransition.transition_to_level(path, new_player_position)
