extends Sprite2D

@export var flying_entity: Node2D
@export var y_offset: float


func _process(_delta):
	global_position = Vector2(
		flying_entity.global_position.x, flying_entity.global_position.y + y_offset
	)
