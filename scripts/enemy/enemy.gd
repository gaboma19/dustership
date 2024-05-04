extends CharacterBody2D
class_name Enemy


@onready var velocity_component = $VelocityComponent
@onready var state_machine = %StateMachine
@onready var animation_player = $AnimationPlayer


func set_stunned(_value: bool):
	pass
