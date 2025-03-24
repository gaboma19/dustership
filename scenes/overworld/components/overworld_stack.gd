extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var layers: Array[Node] = $Layers.get_children()


func move_up():
	for layer in layers:
		var final_val = Vector2(layer.position.x, layer.position.y - 16)
		
		var tween = create_tween()
		tween.tween_property(layer, "position", final_val, 1.0)
		
		await get_tree().create_timer(0.2).timeout


func reset():
	animation_player.stop()
