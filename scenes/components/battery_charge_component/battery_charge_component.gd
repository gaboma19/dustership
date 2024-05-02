extends Node
class_name BatteryChargeComponent

signal charged

var is_charged: bool = false


func set_charged(value):
	is_charged = value
	charged.emit()
