extends StaticBody2D

@export var path: String
@export var new_player_position: Vector2

@onready var interaction_area = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	animation_player.play("set_open")
	close()


func set_opened(value: bool):
	if value:
		animation_player.play("set_open")
		interaction_area.monitoring = false


func set_interactable(value: bool):
	interaction_area.monitoring = value


func open():
	animation_player.play("open")
	interaction_area.monitoring = false
	$AudioStreamPlayer2D.play()


func close():
	animation_player.play("close")
	$DoorCloseAudioStreamPlayer.play()


func on_interact():
	const ANIMATION_LENGTH = 1.4
	
	open()
	await get_tree().create_timer(ANIMATION_LENGTH).timeout
	
	MusicManager.fade_out(10)
	ScreenTransition.transition_to_level(path, new_player_position)
