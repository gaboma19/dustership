extends Area2D


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(enemy: Enemy):
	var aggro_area
	
	if enemy.has_node("AggroArea"):
		aggro_area = enemy.get_node("AggroArea")
	else:
		return
	
	aggro_area.modify_circle_shape_radius(500)
