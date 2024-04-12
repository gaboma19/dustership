extends Enemy

@onready var velocity_component = $VelocityComponent
@onready var animation_tree = $AnimationTree


func _process(_delta):
	if velocity.is_zero_approx():
		set_moving(false)
	else:
		set_moving(true)


func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)


func set_attacking(value):
	animation_tree.set("parameters/conditions/is_attacking", value)
