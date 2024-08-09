extends CharacterBody2D
class_name Enemy

@onready var velocity_component = $VelocityComonent
@onready var state_machine = %StateMachine
@onready var animation_player = $AnimationPlayer
@onready var sprite = %Sprite2D
@onready var animation_tree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")


func update_animation_tree():
	pass


func set_stunned(_value: bool):
	pass


func kill():
	queue_free()
