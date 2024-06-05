# telitz_denz_hide.gd
extends State

@onready var telitz_denz = owner as Npc


func enter(_msg := {}) -> void:
	telitz_denz.hide()
