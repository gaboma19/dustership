extends Area2D


func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func on_body_entered(body: Node2D):
	body.global_position.y -= 4


func on_body_exited(body: Node2D):
	body.global_position.y += 4
