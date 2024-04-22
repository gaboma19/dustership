extends CanvasLayer

var is_closing: bool
var level_file_path: String

@onready var panel_container = %PanelContainer
@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel
@onready var continue_button = %ContinueButton
@onready var quit_button = %QuitButton


func _ready():
	continue_button.pressed.connect(on_continue_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	get_tree().paused = true
	animate_open()
	
	continue_button.grab_focus()


func animate_open():
	$AnimationPlayer.play("default")
	
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


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


func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "You lost!"


func on_continue_button_pressed():
	close()
	ScreenTransition.restart_game(level_file_path)
	get_tree().paused = false


func on_quit_button_pressed():
	get_tree().quit()
