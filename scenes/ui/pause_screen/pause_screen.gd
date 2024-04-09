extends CanvasLayer

enum Screens { INVENTORY, MAP, OPTIONS }
var selected_screen: int = 0
var is_closing

@onready var panel_container = %PanelContainer
@onready var inventory_grid_scene = preload("res://scenes/ui/pause_screen/inventory_grid.tscn")
@onready var map_scene = preload("res://scenes/ui/pause_screen/map.tscn")


func _ready():
	get_tree().paused = true
	set_menu_container()
	animate_open()


func _unhandled_input(event):
	if Input.is_action_just_pressed("switch_character"):
		get_tree().root.set_input_as_handled()
		if selected_screen == Screens.size() - 1:
			selected_screen = 0
		else:
			selected_screen += 1
		set_menu_container()
	elif event.is_action_pressed("pause"):
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
	
	var inventory_grid = inventory_grid_scene.instantiate()
	%MenuContainer.add_child(inventory_grid)
	
	var inventory_slots: Array = inventory_grid.get_children()
	for i in range(Inventory.items.size() - 1):
		inventory_slots[i].set_item(Inventory.items[i])


func set_map():
	%Label.text = "Map"
	
	var map = map_scene.instantiate()
	%MenuContainer.add_child(map)


func set_options():
	pass


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
	
	get_tree().paused = false
	queue_free()
