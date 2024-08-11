extends GPUParticles2D


func emit_dust_particle(pos: Vector2 = Vector2.ZERO, z: int = 0):
	position = pos
	z_index = z
	restart()
	emitting = true
