extends ParallaxLayer

@export var cloud_speed: float = -10


func _process(delta):
	motion_offset.x += cloud_speed * delta
