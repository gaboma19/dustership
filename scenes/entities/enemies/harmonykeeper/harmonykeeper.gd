extends Enemy


func _process(_delta):
	if velocity.is_zero_approx():
		set_moving(false)
	else:
		set_moving(true)
		update_blend_position(velocity.normalized())


func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)


func set_attacking(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", not value)
	animation_tree.set("parameters/conditions/is_attacking", value)


func set_stunned(value: bool):
	if value:
		animation_tree.set("parameters/idle/TimeScale/scale", 0)
		animation_tree.set("parameters/move/TimeScale/scale", 0)
		animation_tree.set("parameters/attack/TimeScale/scale", 0)
	else:
		animation_tree.set("parameters/idle/TimeScale/scale", 1)
		animation_tree.set("parameters/move/TimeScale/scale", 1)
		animation_tree.set("parameters/attack/TimeScale/scale", 1)


func update_blend_position(direction: Vector2):
	animation_tree["parameters/idle/BlendSpace2D/blend_position"] = direction
	animation_tree["parameters/move/BlendSpace2D/blend_position"] = direction
	animation_tree["parameters/attack/BlendSpace2D/blend_position"] = direction
