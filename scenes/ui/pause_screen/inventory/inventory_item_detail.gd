extends PanelContainer

var item: InventoryItem
var is_closing: bool
var is_opening: bool


func _ready():
	%UseButton.pressed.connect(on_use_button_pressed)
	%TextureRect.texture = item.texture
	%DescriptionLabel.text = item.description
	%UseButton.visible = item.is_usable
	%UseButton.grab_focus()
	animate_open()


func _unhandled_input(event):
	if !is_opening and event.is_action_pressed("toggle_hold"):
		get_tree().root.set_input_as_handled()
		close()


func animate_open():
	pivot_offset = size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	is_opening = true
	await get_tree().create_timer(0.4).timeout
	is_opening = false


func close():
	if is_closing:
		return
	is_closing = true
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3) \
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	GameEvents.emit_inventory_item_detail_closed()
	queue_free()


func on_use_button_pressed():
	item.use()
	close()
