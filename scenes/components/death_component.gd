extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D


func _ready():
	health_component.died.connect(on_died)


func get_texture_from_atlas():	
	@warning_ignore("integer_division")
	var sprite_dimensions = Vector2(
		sprite.texture.get_width() / sprite.hframes,
		sprite.texture.get_height() / sprite.vframes)
	var region = Rect2(sprite.frame_coords, sprite_dimensions)
	
	var atlas = AtlasTexture.new()
	atlas.atlas = sprite.texture
	atlas.region = region
	
	return atlas

	
func on_died():
	if owner == null || not owner is Node2D:
		return
		
	$GPUParticles2D.texture = get_texture_from_atlas()
		
	var spawn_position = owner.global_position
	
	var entities = get_tree().get_first_node_in_group("entities")
	get_parent().remove_child(self)
	entities.add_child(self)
	
	global_position = spawn_position
	$AnimationPlayer.play("default")
