extends Area2D

@export_enum("One", "Two") var elevation: int


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	var player = body as Player
	
	match elevation:
		0:
			player.set_collision_mask_value(6, true)
		1:
			player.set_collision_mask_value(6, false)
