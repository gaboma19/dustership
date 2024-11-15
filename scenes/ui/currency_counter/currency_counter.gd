extends CanvasLayer

@onready var steel_label = %SteelLabel
@onready var bytes_label = %BytesLabel


func _ready():
	hide()
	
	GameEvents.steel_collected.connect(on_currency_collected)
	GameEvents.bytes_gained.connect(on_currency_collected)
	set_counter()


func set_counter():
	steel_label.text = format_number(PlayerVariables.steel)
	bytes_label.text = format_number(PlayerVariables.bytes)


func format_number(value) -> String:
	value = str(round(value))
	var output := ""
	
	for i in range(0, value.length()):
		if i != 0 and i % 3 == value.length() % 3:
			output += ","
		output += value[i]
	
	return output


func on_currency_collected(_value):
	set_counter()
