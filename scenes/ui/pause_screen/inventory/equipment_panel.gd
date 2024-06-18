extends PanelContainer


func _ready():
	GameEvents.cube_joined.connect(on_cube_joined)
	GameEvents.telitz_joined.connect(on_telitz_joined)
	
	%SwordSprite.visible = PlayerVariables.has_sword


func on_cube_joined():
	var cube_container = $MarginContainer/VBoxContainer/HBoxContainer2
	cube_container.show()


func on_telitz_joined():
	var telitz_container = $MarginContainer/VBoxContainer/HBoxContainer3
	telitz_container.show()
