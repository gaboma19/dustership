extends CharacterBody2D
class_name Enemy


@onready var velocity_component = $VelocityComponent
@onready var state_machine = %StateMachine
@onready var animation_player = $AnimationPlayer
@onready var sprite = %Sprite2D


func set_stunned(_value: bool):
	pass


func kill():
	queue_free()
