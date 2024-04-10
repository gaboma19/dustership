extends CanvasLayer

enum Screens { INVENTORY, MAP, OPTIONS }
var selected_screen: int = PlayerVariables.pause_menu_screen
var is_closing
var map_pin_cell: Vector2i

@onready var panel_container = %PanelContainer
@onready var inventory_container_scene = preload("res://scenes/ui/pause_screen/inventory_container.tscn")
@onready var map_scene = preload("res://scenes/ui/pause_screen/map.tscn")


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
	elif event.is_action_pressed("pause") or event.is_action_pressed("toggle_hold"):
		get_tree().root.set_input_as_handled()
		close()


func set_menu_container():
	for child in %MenuContainer.get_children():
		child.queue_free()
	
	match selected_screen:
		Screens.INVENTORY:
			set_inventory_grid()
		Screens.MAP:
			set_map()
		Screens.OPTIONS:
			set_options()


func set_inventory_grid():
	%Label.text = "Inventory"
	
	var inventory_container = inventory_container_scene.instantiate()
	%MenuContainer.add_child(inventory_container)
	
	var inventory_slots: Array = inventory_container.get_slots()
	for i in range(Inventory.items.size() - 1):
		inventory_slots[i].set_item(Inventory.items[i])


func set_map():
	%Label.text = "Map"
	
	var map = map_scene.instantiate()
	%MenuContainer.add_child(map)
	map.draw_pin(map_pin_cell)


func set_options():
	%Label.text = "Options"


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
	
	PlayerVariables.pause_menu_screen = selected_screen
	
	$AnimationPlayer.play_backwards("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()
