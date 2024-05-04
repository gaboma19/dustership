extends Area2D

@export var path: String
@export var new_player_position: Vector2


func _ready():
	body_entered.connect(on_body_entered)
	
	
func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	set_deferred("monitoring", false)

	ScreenTransition.transition_to_level(path, new_player_position)
