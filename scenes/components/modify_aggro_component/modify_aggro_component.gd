extends Area2D


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(enemy: Enemy):
	var aggro_area = enemy.get_node("AggroArea")
	if aggro_area == null:
		return
	
	aggro_area.modify_circle_shape_radius(500)
