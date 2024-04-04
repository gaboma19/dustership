extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	animated_sprite_2d.play()
	interaction_area.monitoring = false
