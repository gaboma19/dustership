extends Node2D

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	MusicManager.fade_out(10)
	interaction_area.set_deferred("monitoring", false)
	
	ScreenTransition.transition_to_overworld()
