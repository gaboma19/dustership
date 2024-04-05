extends Node2D

@onready var interaction_area = $InteractionArea
@onready var left_animation_player: AnimationPlayer = $EchelonDoorLeft.get_node("AnimationPlayer")
@onready var right_animation_player: AnimationPlayer = $EchelonDoorRight.get_node("AnimationPlayer")


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	left_animation_player.play("open")
	right_animation_player.play("open")
	interaction_area.monitoring = false
