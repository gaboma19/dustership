extends Sprite2D
class_name OverworldPlayer

var is_moving: bool = false

@onready var animation_player = $AnimationPlayer


func _ready():
	show()
	animation_player.play("enter")


func set_is_moving(value: bool):
	is_moving = value


func move(vector: Vector2i):
	var active_layer = OverworldVariables.active_layer
	
	var new_cell = OverworldVariables.player_map_position + vector
	
	if active_layer.is_cell_walkable(new_cell):
		OverworldVariables.player_map_position = new_cell
		var new_position = active_layer.map_to_global(new_cell)
		
		set_is_moving(true)
		var tween = create_tween()
		tween.tween_property(self, "global_position", new_position, 0.2)
		tween.tween_callback(set_is_moving.bind(false))


func exit():
	animation_player.play("exit")
	await get_tree().create_timer(0.6).timeout
	queue_free()
