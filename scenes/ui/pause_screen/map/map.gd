extends PanelContainer

@onready var map_pin_scene = preload("res://scenes/ui/pause_screen/map/map_pin.tscn")






func _process(_delta):
	var movement_vector = get_movement_vector()
	#map_tiles.translate(movement_vector)


func get_movement_vector() -> Vector2:
	var direction = Input.get_vector("move_left", "move_right", "move_up",  "move_down")
	
	return direction * -3
