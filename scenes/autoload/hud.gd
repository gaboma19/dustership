extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var currency_counter = $CurrencyCounter


func _ready():
	hide()


func set_hearts():
	health_bar.set_hearts()


func set_counter():
	currency_counter.set_counter()
