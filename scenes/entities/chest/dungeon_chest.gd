extends Chest


func _ready():
	shadow_sprite.animation = animated_sprite_2d.animation
	interaction_area.interact = Callable(self, "on_interact")
	
	chest_id = DungeonManager.get_chest_id()
	
	if EntityVariables.chests.has(chest_id):
		set_state(EntityVariables.chests[chest_id])
	else:
		EntityVariables.chests[chest_id] = { 
			"opened": false,
			"spawned": false }


func set_state(chest_data: Dictionary):
	if chest_data.opened:
		show()
		animated_sprite_2d.set_frame(1)
		interaction_area.monitoring = false
		collision_shape_2d.disabled = false
	
	if chest_data.spawned:
		show()
		interaction_area.monitoring = true
		collision_shape_2d.disabled = false
