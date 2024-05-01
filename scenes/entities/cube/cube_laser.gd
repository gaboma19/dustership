extends RayCast2D

@onready var line_2d = $Line2D


func _ready():
	line_2d.set_texture_repeat(CanvasItem.TEXTURE_REPEAT_ENABLED)
	line_2d.points[1] = Vector2.ZERO
	target_position = Vector2.ZERO


func _physics_process(_delta):
	var cast_point = target_position
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
	line_2d.points[1] = cast_point
