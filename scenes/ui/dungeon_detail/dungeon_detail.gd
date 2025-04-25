extends AnimatedPanel

signal canceled
signal continued

var location_name: String

@onready var location_name_label: Label = %LocationName


func _ready():
	set_state()
	open()


func set_state():
	location_name_label.text = location_name


func cancel():
	canceled.emit()
	close()


func on_interact():
	continued.emit()
	close()
