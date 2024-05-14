extends StaticBody2D

@export var speed: float = 200

@onready var hitbox_component = $HitboxComponent


func _ready():
	hitbox_component.body_entered.connect(on_body_or_area_entered)
	hitbox_component.area_entered.connect(on_body_or_area_entered)


func _process(delta):
	global_position = global_position.move_toward(Vector2.UP, delta * speed)


func on_body_or_area_entered(_body):
	queue_free()
