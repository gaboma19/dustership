extends Area2D
class_name InteractionArea

@export var action_name: String = "Interact"


var interact: Callable = func():
	pass
	
	
func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
	
func on_body_entered(_body: Node2D):
	InteractionManager.register_area(self)
	
	
func on_body_exited(_body: Node2D):
	InteractionManager.unregister_area(self)
