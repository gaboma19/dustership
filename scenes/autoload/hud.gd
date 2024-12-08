extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var inventory_display = $InventoryDisplay


func _ready():
	hide()


func set_hearts():
	health_bar.set_hearts()


func set_counter():
	health_bar.set_counter()
