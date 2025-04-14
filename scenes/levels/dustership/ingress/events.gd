extends Node

@export var is_portal_closing: bool = false

@onready var animation_tree: AnimationTree = $"../Background/AnimationTree"
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


func _ready():
	if is_portal_closing:
		state_machine.travel("portal_active")
		await get_tree().create_timer(2).timeout
		state_machine.travel("portal_close")


func open_portal():
	state_machine.travel("portal_open")


func close_portal():
	state_machine.travel("portal_close")
