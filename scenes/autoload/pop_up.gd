extends CanvasLayer

signal closed

var is_closing: bool
var is_opening: bool

@onready var panel_container = %PanelContainer


func _ready():
	%OKButton.pressed.connect(on_ok_button_pressed)
	visible = false


func _unhandled_input(event):
	if not visible: 
		return

	if event.is_action_pressed("ui_cancel") and !is_opening:
		get_tree().root.set_input_as_handled()
		close()


func open_pop_up(
		item: InventoryItem,
		label_text: String = item.pop_up_text):
	visible = true
	get_tree().paused = true
	animate_open()
	
	%TextureRect.texture = item.texture
	%Label.text = label_text


func animate_open():
	$AnimationPlayer.play("default")
	
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	is_opening = true
	await get_tree().create_timer(0.4).timeout
	is_opening = false
	%OKButton.grab_focus()


func close():
	if is_closing:
		return
	is_closing = true
	
	$AnimationPlayer.play_backwards("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	is_closing = false
	get_tree().paused = false
	visible = false
	%SwordTutorial.visible = false
	%PartyTutorial.visible = false
	closed.emit()


func set_sword_instructions():
	%SwordTutorial.visible = true


func open_party_instructions():
	visible = true
	get_tree().paused = true
	animate_open()
	
	%TextureRect.texture = preload("res://assets/cube/cube_texture.png")
	%Label.text = "Cube joins the party!"
	%PartyTutorial.visible = true


func on_ok_button_pressed():
	close()
