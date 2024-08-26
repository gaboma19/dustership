extends Area2D

const OVERWORLD_PATH = "res://scenes/overworld/overworld.tscn"


func _ready():
	body_entered.connect(on_body_entered)


func transition_to_overworld():
	MusicManager.fade_out(10)
	
	set_deferred("monitoring", false)

	ScreenTransition.transition_out()
	await get_tree().create_timer(0.4).timeout
	
	get_tree().change_scene_to_file.bind(OVERWORLD_PATH).call_deferred()
	
	ScreenTransition.transition_in()


func on_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	transition_to_overworld()
