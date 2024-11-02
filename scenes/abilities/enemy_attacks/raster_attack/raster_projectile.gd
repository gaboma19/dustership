extends StaticBody2D

const EXPIRATION_TIME = 10.0

@export var speed: float = 1

@onready var hitbox_component = $HitboxComponent


func _ready():
	hitbox_component.body_entered.connect(on_body_or_area_entered)
	hitbox_component.area_entered.connect(on_body_or_area_entered)
	
	await get_tree().create_timer(EXPIRATION_TIME).timeout
	queue_free()


func _process(delta):
	global_position = global_position.move_toward($Target.global_position, delta * speed)


func on_body_or_area_entered(_body):
	queue_free()
