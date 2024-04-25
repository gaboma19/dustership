extends Node

signal player_damaged
signal player_healed
signal steel_collected(value: int)
signal inventory_item_detail_closed


func emit_player_damaged():
	player_damaged.emit()


func emit_player_healed():
	player_healed.emit()


func emit_steel_collected(value: int):
	steel_collected.emit(value)


func emit_inventory_item_detail_closed():
	inventory_item_detail_closed.emit()
