extends StaticBody2D
class_name Battery

@export var battery_id: String
@export var chargeable_entity: Node2D

var battery_charge_component: BatteryChargeComponent


func _ready():
	if chargeable_entity != null:
		battery_charge_component = chargeable_entity.get_node(
			"BatteryChargeComponent")
	
	if EntityVariables.batteries.has(battery_id):
		set_on(EntityVariables.batteries[battery_id].on)
	else:
		EntityVariables.batteries[battery_id] = { "on": false }


func set_on(value):
	if value:
		$AnimationPlayer.play("on")
		battery_charge_component.set_charged(true)


func turn_on():
	EntityVariables.batteries[battery_id].on = true
	$AnimationPlayer.play("on")
	$AudioStreamPlayer2D.play()
	battery_charge_component.set_charged(true)
