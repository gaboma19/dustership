extends Area2D
class_name InteractionArea

@export var action_name: String = "Interact"


var interact: Callable = func():
	pass


func _ready():
	body_entered.connect(on_player_entered)
	body_exited.connect(on_player_exited)
	area_entered.connect(on_player_entered)
	area_exited.connect(on_player_exited)


func on_player_entered(_player: Node2D):
	InteractionManager.register_area(self)


func on_player_exited(_player: Node2D):
	InteractionManager.unregister_area(self)
