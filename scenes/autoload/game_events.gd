extends Node

signal player_damaged()


func emit_player_damaged():
	player_damaged.emit()
