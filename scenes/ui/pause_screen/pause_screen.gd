extends CanvasLayer

enum Screens { INVENTORY, MAP, GAME }

@export var inventory_container_scene: PackedScene
@export var map_scene: PackedScene
@export var game_container_scene: PackedScene

var selected_screen: int = PlayerVariables.pause_menu_screen
var is_closing: bool
var is_opening: bool
var map_pin_cell: Vector2i

@onready var menu_container: PanelContainer = %MenuContainer
@onready var panel_container: PanelContainer = %PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var header: Label = %Header


func _ready():
	get_tree().paused = true
	set_menu_container()
	animate_open()


func _unhandled_input(event):
	if event.is_action_pressed("switch_character"):
		get_tree().root.set_input_as_handled()
		if selected_screen == Screens.size() - 1:
			selected_screen = 0
		else:
			selected_screen += 1
		set_menu_container()
	elif (
		!is_opening
		and
		!PopUp.visible
		and (
			event.is_action_pressed("pause")
			or event.is_action_pressed("ui_cancel")
		)
	):
		get_tree().root.set_input_as_handled()
		close()


func set_menu_container():
	for child in menu_container.get_children():
		child.queue_free()
	
	match selected_screen:
		Screens.INVENTORY:
			set_inventory_grid()
		Screens.MAP:
			set_map()
		Screens.GAME:
			set_game()


func set_inventory_grid():
	header.text = "Inventory"
	
	var inventory_container = inventory_container_scene.instantiate()
	menu_container.add_child(inventory_container)
	
	inventory_container.set_slots()


func set_map():
	header.text = "Map"
	
	var map = map_scene.instantiate()
	menu_container.add_child(map)
	map.draw_pin(map_pin_cell)


func set_game():
	header.text = "Game"
	
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
