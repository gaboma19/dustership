extends PanelContainer

signal continue_pressed

@onready var continue_button = %ContinueButton
@onready var texture_rect = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect


func _ready():
	continue_button.pressed.connect(on_continue_pressed)


func on_continue_pressed():
	pass
