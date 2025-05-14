extends StaticBody2D

var dragging = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.is_pressed()
	
	if event is InputEventMouseMotion and dragging:
		global_position = event.position
