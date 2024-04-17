extends CanvasLayer

var is_closing: bool
var is_opening: bool

@onready var panel_container = %PanelContainer


func _ready():
	get_tree().paused = true
	animate_open()


func _unhandled_input(event):
	if event.is_action_pressed("interact") and !is_opening:
		get_tree().root.set_input_as_handled()
		close()


func set_pop_up(item: InventoryItem):
	%TextureRect.texture = item.texture
	%Label.text = "Found a " + item.name + "!"


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
	
	get_tree().paused = false
	queue_free()
