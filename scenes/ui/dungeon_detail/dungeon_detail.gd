extends AnimatedPanel

signal continued

@export var none_infection_icon: Texture2D
@export var mild_infection_icon: Texture2D
@export var moderate_infection_icon: Texture2D
@export var severe_infection_icon: Texture2D

var location_name: String
var infection_level: Constants.InfectionLevel

@onready var continue_button: Button = %ContinueButton
@onready var location_name_label: Label = %LocationName
@onready var infection_icon: TextureRect = %InfectionIcon
@onready var infection_level_label: Label = %InfectionLevel
@onready var infection_panel: PanelContainer = %InfectionPanel


func _ready():
	continue_button.grab_focus()
	continue_button.pressed.connect(on_continue_pressed)
	
	set_state()
	open()
	
	#_test_infection_level(Constants.InfectionLevel.MILD)


func set_state():
	location_name_label.text = location_name
	
	match infection_level:
		Constants.InfectionLevel.NONE:
			infection_icon.texture = none_infection_icon
			infection_level_label.text = "NONE"
		Constants.InfectionLevel.MILD:
			infection_icon.texture = mild_infection_icon
			infection_level_label.text = "MILD"
		Constants.InfectionLevel.MODERATE:
			infection_icon.texture = moderate_infection_icon
			infection_level_label.text = "MODERATE"
		Constants.InfectionLevel.SEVERE:
			infection_icon.texture = severe_infection_icon
			infection_level_label.text = "SEVERE"
			#infection_panel.set_theme_type_variation(&"PanelContainerRed")


func on_continue_pressed():
	close()
	continued.emit()


func _test_infection_level(level: Constants.InfectionLevel):
	infection_level = level
	set_state()
