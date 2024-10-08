extends CanvasLayer

enum Screens { INVENTORY, GAME }

@export var inventory_container_scene: PackedScene
#@export var map_scene: PackedScene
@export var game_container_scene: PackedScene

var selected_screen: int = PlayerVariables.pause_menu_screen
var is_closing: bool
var is_opening: bool
var map_pin_cell: Vector2i

@onready var menu_container: PanelContainer = %MenuContainer
@onready var panel_container: PanelContainer = %PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var header: Label = %Header
@onready var left_button_2 = %LeftButton2
@onready var left_button = %LeftButton
@onready var right_button = %RightButton
@onready var right_button_2 = %RightButton2


func _ready():
	get_tree().paused = true
	set_menu_container()
	animate_open()
	
	left_button.pressed.connect(tab_left)
	left_button_2.pressed.connect(tab_left)
	right_button.pressed.connect(tab_right)
	right_button_2.pressed.connect(tab_right)


func _unhandled_input(event):
	if not PopUp.visible:
		if event.is_action_pressed("tab_right"):
			get_tree().root.set_input_as_handled()
			right_button.audio_stream_player.play()
			tab_right()
		elif event.is_action_pressed("tab_left"):
			get_tree().root.set_input_as_handled()
			left_button.audio_stream_player.play()
			tab_left()
		elif (
			not is_opening
			and (
				event.is_action_pressed("pause") 
				or event.is_action_pressed("ui_cancel"))):
			get_tree().root.set_input_as_handled()
			close()


func tab_right():
	if selected_screen == Screens.size() - 1:
		selected_screen = 0
	else:
		selected_screen += 1
	set_menu_container()


func tab_left():
	if selected_screen == 0:
		selected_screen = Screens.size() - 1
	else:
		selected_screen -= 1
	set_menu_container()


func set_menu_container():
	for child in menu_container.get_children():
		child.queue_free()
	
	match selected_screen:
		Screens.INVENTORY:
			set_inventory_grid()
		Screens.GAME:
			set_game()
		#Screens.MAP:
			#set_map()


func set_inventory_grid():
	header.text = "INVENTORY"
	
	var inventory_container = inventory_container_scene.instantiate()
	menu_container.add_child(inventory_container)
	
	inventory_container.set_slots()


#func set_map():
	#header.text = "MAP"
	#
	#var map = map_scene.instantiate()
	#menu_container.add_child(map)


func set_game():
	header.text = "GAME"
	
	var game_container = game_container_scene.instantiate()
	menu_container.add_child(game_container)


func animate_open():
	animation_player.play("default")
	
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
	
	PlayerVariables.pause_menu_screen = selected_screen
	
	animation_player.play_backwards("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()
