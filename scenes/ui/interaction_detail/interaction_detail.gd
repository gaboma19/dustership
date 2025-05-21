extends AnimatedPanel

var action_name: String

@onready var label = %Label


func _ready():
	position = Vector2.ZERO
	set_state()
	open()


func set_state():
	
	label.text = action_name
	position = Vector2.ZERO
