extends RayCast2D

const LASER_RANGE = 500

var aim_direction: Vector2
var cast_point: Vector2

@onready var line_2d = $Line2D
@onready var animation_player = $AnimationPlayer


func _ready():
	line_2d.points[1] = Vector2.ZERO
	target_position = Vector2.ZERO
	aim_direction = Vector2.ZERO
	
	# only need to process while casting
	set_physics_process(false)


func _physics_process(_delta):
	target_position = aim_direction * LASER_RANGE
	cast_point = target_position
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
	line_2d.points[1] = cast_point


func set_casting(value: bool):
	set_physics_process(value)
	
	if value:
		appear()
	else:
		disappear()


func appear():
	var tween = create_tween()
	tween.tween_method(set_line_target, Vector2.ZERO, target_position, 0.4)


func disappear():
	animation_player.play("disappear")


func set_line_target(value: Vector2):
	line_2d.set_point_position(1, value)
