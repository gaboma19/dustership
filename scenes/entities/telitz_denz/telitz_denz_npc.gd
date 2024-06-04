extends Npc

@export_enum("telitz_denz_1", "telitz_denz_4") var conversation_id: String
@onready var animation_tree: AnimationTree = $AnimationTree


func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
	if not EntityVariables.conversations.has(conversation_id):
		EntityVariables.conversations[conversation_id] = { "interacted": false }


func _process(_delta):
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


func despawn():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite.material, "shader_parameter/alpha", 0, 1.6)
	tween.tween_property(sprite.material, "shader_parameter/effect_factor", 1, 1.6)
	tween.tween_property(sprite.material, "shader_parameter/noise_amount", 1, 1.6)
	tween.tween_property(sprite, "scale", Vector2(3, 3), 1.6)
	tween.chain()
	tween.tween_callback(queue_free)


func on_interact():
	pass
