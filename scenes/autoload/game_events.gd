extends Node

signal player_damaged
signal player_healed
signal steel_collected(value: int)
signal inventory_item_detail_closed
signal player_elevation_changed
signal cube_joined
signal telitz_joined
signal bytes_gained(value: int)


func emit_player_damaged():
	player_damaged.emit()


func emit_player_healed():
	player_healed.emit()


func emit_steel_collected(value: int):
	steel_collected.emit(value)


func emit_bytes_gained(value: int):
	bytes_gained.emit(value)


func emit_inventory_item_detail_closed():
	inventory_item_detail_closed.emit()


func emit_player_elevation_changed(elevation: Constants.Elevations):
	player_elevation_changed.emit(elevation)


func emit_cube_joined():
	cube_joined.emit()


func emit_telitz_joined():
	telitz_joined.emit()
