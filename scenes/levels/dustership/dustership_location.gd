extends TextureButton

@export var location_name: String

@onready var label = $Label


func _ready():
	label.text = location_name
	
	focus_entered.connect(on_selected)
	mouse_entered.connect(on_mouse_entered)
	focus_exited.connect(on_unselected)
	mouse_exited.connect(on_mouse_exited)


func on_mouse_entered():
	grab_focus()
	label.show()


func on_selected():
	label.show()


func on_mouse_exited():
	release_focus()
	label.hide()


func on_unselected():
	label.hide()
