extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var shadow_sprite = $ShadowSprite


func _ready():
	var max_frame = (sprite.hframes * sprite.vframes) - 1
	sprite.frame = randi_range(0, max_frame)
	shadow_sprite.frame = sprite.frame
	sprite.offset.x = randi_range(-2, 2)
	sprite.offset.y = randi_range(-2, 2)


func kill():
	queue_free()
