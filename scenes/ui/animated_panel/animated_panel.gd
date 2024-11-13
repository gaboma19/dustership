extends PanelContainer
class_name AnimatedPanel

var is_opening: bool = false
var is_closing: bool = false

@onready var b_button = %BButton


func _ready():
	b_button.pressed.connect(on_b_pressed)


func _unhandled_input(event):
	if not visible: 
		return

	if event.is_action_pressed("ui_cancel") and not is_opening:
		get_tree().root.set_input_as_handled()
		b_button.audio_stream_player.play()
		close()


func open():
	is_opening = true
	get_tree().paused = true
	
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3) \
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
	get_tree().paused = false
	queue_free()


func on_b_pressed():
	close()
