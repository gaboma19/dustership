extends Enemy


func _process(_delta):
	update_animation_tree()


func update_animation_tree():
	if velocity.is_zero_approx():
		set_moving(false)
	else:
		set_moving(true)


func update_blend_position(value: float):
	animation_tree["parameters/attack/BlendSpace1D/blend_position"] = value


func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)


func set_stunned(value: bool):
	if value:
		animation_tree.set("parameters/idle/TimeScale/scale", 0)
		animation_tree.set("parameters/move/TimeScale/scale", 0)
		animation_tree.set("parameters/attack/TimeScale/scale", 0)
		animation_tree.set("parameters/attack_360/TimeScale/scale", 0)
	else:
		animation_tree.set("parameters/idle/TimeScale/scale", 1)
		animation_tree.set("parameters/move/TimeScale/scale", 1)
		animation_tree.set("parameters/attack/TimeScale/scale", 1)
		animation_tree.set("parameters/attack_360/TimeScale/scale", 1)
