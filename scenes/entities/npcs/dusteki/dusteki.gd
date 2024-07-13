extends Npc

@onready var state_machine = $StateMachine


func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func _process(_delta):
	update_animation_tree()


func update_animation_tree():
	if velocity.is_zero_approx():
		set_moving(false)
	else:
		set_moving(true)
		update_blend_position(velocity.normalized())


func set_moving(value):
	animation_tree.set("parameters/conditions/is_idle", not value)
	animation_tree.set("parameters/conditions/is_moving", value)


func update_blend_position(direction: Vector2):
	animation_tree["parameters/idle/BlendSpace2D/blend_position"] = direction
	animation_tree["parameters/walk/BlendSpace2D/blend_position"] = direction


func on_interact():
	state_machine.transition_to("Scene")
