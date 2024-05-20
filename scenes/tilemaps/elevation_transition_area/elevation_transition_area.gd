extends Area2D

@export_enum("One:1", "Two:2") var elevation: int


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	var player = body as Player
	
	match elevation:
		1:
			player.set_collision_mask_value(6, true)
		2:
			player.set_collision_mask_value(6, false)
