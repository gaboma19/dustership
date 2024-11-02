extends Chest

@onready var animations: PackedStringArray = animated_sprite_2d.sprite_frames.get_animation_names()


func _ready():
	hide()
	
	shadow_sprite.animation = animated_sprite_2d.animation
	interaction_area.interact = Callable(self, "on_interact")
	
	chest_id = DungeonManager.get_chest_id()
	
	if EntityVariables.chests.has(chest_id):
		set_state(EntityVariables.chests[chest_id])
	else:
		create_state()


func create_state():
	var sprite_index = randi_range(0, Chest.Sprites.size() - 1)
	animated_sprite_2d.animation = animations[sprite_index]
	
	EntityVariables.chests[chest_id] = { 
		"opened": false,
		"spawned": false,
		"sprite": sprite_index
	}


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
	
	animated_sprite_2d.animation = animations[chest_data.sprite]


func spawn():
	EntityVariables.chests[chest_id].spawned = true
	interaction_area.monitoring = true
	super()
