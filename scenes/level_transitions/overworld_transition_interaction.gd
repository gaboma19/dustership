extends Node2D

@export var action_name: String

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	interaction_area.action_name = action_name


func on_interact():
	MusicManager.fade_out(10)
	interaction_area.set_deferred("monitoring", false)
	
	ScreenTransition.transition_to_overworld()
