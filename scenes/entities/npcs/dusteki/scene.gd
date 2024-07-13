# npcs/dusteki/scene.gd
extends State

@onready var dusteki = owner as Npc


func enter(_msg := {}) -> void:
	dusteki.speak(["Lorem ipsum dolor sit emet."])
