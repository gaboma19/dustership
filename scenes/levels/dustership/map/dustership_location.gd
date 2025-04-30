extends TextureButton

@export var location_name: String
@export var scene_path: String
@export var player_position: Vector2

@onready var label = $Label


func _ready():
	label.text = location_name
	
	focus_entered.connect(on_focused)
	mouse_entered.connect(on_mouse_entered)
	focus_exited.connect(on_unfocused)
	mouse_exited.connect(on_mouse_exited)
	pressed.connect(on_pressed)


func on_mouse_entered():
	grab_focus()
	label.show()


func on_mouse_exited():
	release_focus()
	label.hide()


func on_focused():
	label.show()


func on_unfocused():
	label.hide()


func on_pressed():
	if scene_path.is_empty():
		return
	
	EntityVariables.last_dustership_location = name
	
	ScreenTransition.transition_to_level_with_active_member_name(
		scene_path, player_position, PartyManager.active_member_name)
