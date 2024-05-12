extends Node2D

signal triggered

@export var door_id: String
@export var trap_area: Area2D

@onready var interaction_area = $InteractionArea
@onready var left_animation_player: AnimationPlayer = $EchelonDoorLeft.get_node("AnimationPlayer")
@onready var right_animation_player: AnimationPlayer = $EchelonDoorRight.get_node("AnimationPlayer")


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	trap_area.body_entered.connect(on_body_entered_trap)
	
	if EntityVariables.doors.has(door_id):
		set_opened(EntityVariables.doors[door_id].opened)
	else:
		EntityVariables.doors[door_id] = { "opened": false }


func set_opened(value: bool):
	if value:
		queue_free()


func open():
	EntityVariables.doors[door_id].opened = true
	left_animation_player.play("open")
	right_animation_player.play("open")
	$AudioStreamPlayer2D.play()
	interaction_area.monitoring = false


func on_interact():
	open()


func on_body_entered_trap(player: Player):
	trap_area.set_deferred("monitoring", false)
	player.state_machine.transition_to("Hold")
	var face_direction = player.global_position.direction_to(global_position)
	player.update_blend_position(face_direction)
	
	EntityVariables.doors[door_id].opened = false
	left_animation_player.play_backwards("open")
	right_animation_player.play_backwards("open")
	await get_tree().create_timer(1.6).timeout
	player.state_machine.transition_to("Active")
	
	triggered.emit()
