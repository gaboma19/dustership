extends Area2D

# slope of the ramp from left to right
@export_enum("Down", "Up") var ramp_slope: String


func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	var velocity_component: VelocityComponent = player.velocity_component
	match ramp_slope:
		"Down":
			velocity_component.is_on_down_ramp = true
		"Up":
			velocity_component.is_on_up_ramp = true


func on_body_exited(body: Node2D):
	var player = PartyManager.get_active_member()
	if body != player:
		return
	
	var velocity_component: VelocityComponent = player.velocity_component
	match ramp_slope:
		"Down":
			velocity_component.is_on_down_ramp = false
		"Up":
			velocity_component.is_on_up_ramp = false
