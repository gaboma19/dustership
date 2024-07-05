extends RayCast2D

const LASER_RANGE = 500

var aim_direction: Vector2

@onready var line_2d = $Line2D


func _ready():
	line_2d.points[1] = Vector2.ZERO
	target_position = Vector2.ZERO
	aim_direction = Vector2.ZERO
	
	line_2d.hide()
	
	# only need to process while casting
	set_physics_process(false)


func _physics_process(_delta):
	target_position = aim_direction * LASER_RANGE
	var cast_point = target_position
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
	line_2d.points[1] = cast_point


func set_casting(value: bool):
	set_physics_process(value)
	line_2d.set_visible(value)
	
	await get_tree().process_frame
