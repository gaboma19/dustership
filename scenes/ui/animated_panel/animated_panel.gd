extends PanelContainer
class_name AnimatedPanel

signal canceled

var is_opening: bool = false
var is_closing: bool = false

@onready var audio_stream_player = $AudioStreamPlayer
@onready var animation_player = $AnimationPlayer


func _unhandled_input(event):
	if not visible: 
		return

	if event.is_action_pressed("ui_cancel") and not is_opening:
		get_tree().root.set_input_as_handled()
		close()


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
	get_tree().paused = true
	
	is_opening = false


func close():
	if is_closing:
		return
	is_closing = true
	
	audio_stream_player.play()
	canceled.emit()
	
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	is_closing = false
	get_tree().paused = false
	queue_free()
