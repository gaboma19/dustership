extends Node

const DEATH_COMPONENT_MATERIAL = preload("res://resources/materials/death_component_material.tres")
const CUBE_LASER_BEAM = preload("res://resources/materials/cube_laser_beam.tres")
const CUBE_LASER_CAST = preload("res://resources/materials/cube_laser_cast.tres")
const CUBE_LASER_COLLISION = preload("res://resources/materials/cube_laser_collision.tres")
const DUST_PARTICLES = preload("res://resources/materials/dust_particles.tres")

const HIT_FLASH_MATERIAL = preload("res://resources/materials/hit_flash_material.tres")
const ECHELON_PORTAL = preload("res://resources/materials/echelon_portal.tres")
const SPAWN_MATERIAL = preload("res://resources/materials/spawn_material.tres")
const STUN = preload("res://resources/materials/stun.tres")
const HOLOGRAM = preload("res://resources/materials/hologram.tres")
const GRAIN_POST_PROCESS_MATERIAL = preload("res://resources/materials/grain_post_process_material.tres")
const FIRE_DISSOLVE_MATERIAL = preload("res://resources/materials/fire_dissolve_material.tres")

var particle_materials = [
	DEATH_COMPONENT_MATERIAL,
	CUBE_LASER_BEAM,
	CUBE_LASER_CAST,
	CUBE_LASER_COLLISION,
	DUST_PARTICLES
]
var shader_materials = [
	HIT_FLASH_MATERIAL,
	SPAWN_MATERIAL,
	ECHELON_PORTAL,
	STUN,
	HOLOGRAM,
	GRAIN_POST_PROCESS_MATERIAL,
	FIRE_DISSOLVE_MATERIAL
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
