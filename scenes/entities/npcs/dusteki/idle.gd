# npcs/dusteki/idle.gd
extends State

@onready var dusteki = owner as Npc


func enter(_msg := {}) -> void:
	dusteki.velocity_component.stop()
