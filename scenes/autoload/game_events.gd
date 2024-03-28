extends Node

signal player_damaged
signal steel_collected(value: int)


func emit_player_damaged():
	player_damaged.emit()


func emit_steel_collected(value: int):
	steel_collected.emit(value)
