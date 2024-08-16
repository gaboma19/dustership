extends Node2D

const OVERWORLD_PATH = "res://scenes/overworld/overworld.tscn"

@onready var interaction_area = $InteractionArea


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func transition_to_overworld():
	MusicManager.fade_out(10)
	
	interaction_area.set_deferred("monitoring", false)

	ScreenTransition.transition_out()
	await get_tree().create_timer(0.4).timeout
	
	get_tree().change_scene_to_file.bind(OVERWORLD_PATH).call_deferred()
	
	ScreenTransition.transition_in()


func on_interact():
	transition_to_overworld()
