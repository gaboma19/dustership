extends StaticBody2D

@export var door_id: String

@onready var interaction_area = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if EntityVariables.doors.has(door_id):
		set_opened(EntityVariables.doors[door_id].opened)
	else:
		EntityVariables.doors[door_id] = { "opened": false }


func set_opened(value: bool):
	if value:
		animation_player.play("set_open")
		interaction_area.monitoring = false


func set_interactable(value: bool):
	interaction_area.monitoring = value


func open():
	EntityVariables.doors[door_id].opened = true
	animation_player.play("open")
	interaction_area.monitoring = false
	$AudioStreamPlayer2D.play()


func close():
	EntityVariables.doors[door_id].opened = false
	animation_player.play_backwards("open")
	$DoorCloseAudioStreamPlayer.play()


func on_interact():
	open()
