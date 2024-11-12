extends AnimatedPanel

signal continue_pressed

var location_name: String
var infection_level: Constants.InfectionLevel

@onready var continue_button = %ContinueButton
@onready var location_name_label = %LocationName
@onready var infection_icon = %InfectionIcon


func _ready():
	continue_button.pressed.connect(on_continue_pressed)
	
	open()


func on_continue_pressed():
	continue_pressed.emit()
	close()
