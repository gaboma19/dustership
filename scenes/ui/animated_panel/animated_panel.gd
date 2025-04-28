extends PanelContainer
class_name AnimatedPanel

var is_opening: bool = false
var is_closing: bool = false


func open():
	is_opening = true
	
	pivot_offset = size / 2
	
	modulate.a = 0
	scale = Vector2.ZERO
	await get_tree().process_frame # https://github.com/godotengine/godot/issues/20623
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3) \
		.from(Vector2.ZERO) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	is_opening = false


func close():
	if is_closing:
		return
	is_closing = true
	
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	is_closing = false
	queue_free()
