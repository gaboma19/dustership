extends AnimatedPanel

signal continue_pressed

@onready var continue_button = %ContinueButton
@onready var location_name = %LocationName
@onready var infection_icon = %InfectionIcon


func _ready():
	continue_button.pressed.connect(on_continue_pressed)


func on_continue_pressed():
	continue_pressed.emit()
