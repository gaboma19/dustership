extends CanvasLayer

signal closed(msg)

var is_closing: bool
var is_opening: bool

@onready var panel_container = %PanelContainer
@onready var item_get_container = %ItemGetContainer
@onready var decision_container = %DecisionContainer
@onready var yes_button = %YesButton
@onready var no_button = %NoButton


func _ready():
	%OKButton.pressed.connect(on_ok_button_pressed)
	yes_button.pressed.connect(on_yes_button_pressed)
	no_button.pressed.connect(on_no_button_pressed)
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
	item_get_container.show()
	animate_open()
	get_tree().paused = true
	%OKButton.grab_focus()
	
	%TextureRect.texture = item.texture
	%Label.text = label_text


func animate_open():
	$AnimationPlayer.play("default")
	is_opening = true
	
	panel_container.modulate.a = 0
	panel_container.scale = Vector2.ZERO
	await get_tree().process_frame # https://github.com/godotengine/godot/issues/20623
	
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3) \
		.from(Vector2.ZERO) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	is_opening = false


func close():
	if is_closing:
		return
	is_closing = true
	
	$AnimationPlayer.play_backwards("default")
	
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	is_closing = false
	get_tree().paused = false
	visible = false
	%SwordTutorial.visible = false
	%PartyTutorial.visible = false
	item_get_container.hide()
	decision_container.hide()


func set_sword_instructions():
	%SwordTutorial.visible = true


func open_party_instructions():
	visible = true
	item_get_container.show()
	%PartyTutorial.show()
	animate_open()
	%OKButton.grab_focus()
	get_tree().paused = true
	
	%TextureRect.texture = preload("res://assets/cube/cube_texture.png")
	%Label.text = "Cube joins the party!"


func open_decision_container(text: String, grab_focus_no: bool = false):
	var label = %DecisionLabel
	label.text = text
	
	show()
	decision_container.show()
	animate_open()
	get_tree().paused = true
	if grab_focus_no:
		no_button.grab_focus()
	else:
		yes_button.grab_focus()


func on_ok_button_pressed():
	close()
	closed.emit("Ok")


func on_yes_button_pressed():
	close()
	closed.emit("Yes")


func on_no_button_pressed():
	close()
	closed.emit("No")
