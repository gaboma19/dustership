extends CanvasLayer

var death_component_material = preload("res://resources/materials/death_component_material.tres")
var hit_flash_material = preload("res://scenes/components/hit_flash_component/hit_flash_component_material.tres")

var particle_materials = [
	death_component_material
]
var shader_materials = [
	hit_flash_material
]

var frames = 0
var loaded = false


func _ready():
	load_particles()
	load_shaders()


func _physics_process(_delta):
	if frames >= 3:
		set_physics_process(false)
		loaded = true
	frames += 1


func load_particles():
	for material in particle_materials:
		var particles_instance = GPUParticles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)


func load_shaders():
	var sprites = []
	for material in shader_materials:
		var sprite = Sprite2D.new()
		sprite.texture = PlaceholderTexture2D.new()
		sprite.material = material
		add_child(sprite)
		sprites.append(sprite)
		
	# Remove the sprites after being rendered
	await get_tree().create_timer(0.2).timeout
	for sprite in sprites:
		sprite.queue_free()
