extends Area2D

const LINES: Array[String] = [
	"I better grab my sword first."
]

@export var path: String
@export var new_player_position: Vector2


func _ready():
	set_deferred("monitoring", true)
	body_entered.connect(on_body_entered)
	
	
func on_body_entered(player: Node2D):
	if not player is Player:
		return
	
	if PlayerVariables.has_sword:
		set_deferred("monitoring", false)
		ScreenTransition.transition_to_level(path, new_player_position)
	else:
		player.set_moving(false)
		player.speak(LINES)
