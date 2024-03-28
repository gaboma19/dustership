extends CanvasLayer


func _ready():
	GameEvents.steel_collected.connect(on_steel_collected)
	%Label.text = format_number(PlayerVariables.steel)
	
	
func on_steel_collected(_value):
	%Label.text = format_number(PlayerVariables.steel)
	
	
func format_number(value) -> String:
	value = str(round(value))
	var output := ""

	for i in range(0, value.length()):
		if i != 0 and i % 3 == value.length() % 3:
			output += ","
		output += value[i]

	return output
