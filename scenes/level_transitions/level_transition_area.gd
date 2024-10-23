extends Area2D
class_name LevelTransitionArea

@export var path: String
@export var new_player_position: Vector2


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	MusicManager.fade_out(10)
	
	set_deferred("monitoring", false)

	ScreenTransition.transition_to_level(path, new_player_position)
