class_name Constants

enum CharacterNames { APRIL, CUBE, TELITZ }
enum Elevations { ONE, TWO, THREE, FOUR }

const ELEVATION_COLLISION_LAYERS = {
	Elevations.ONE: 6,
	Elevations.TWO: 10,
	Elevations.THREE: 11,
	Elevations.FOUR: 13,
}

const PLAYER_POSITIONS_DICT: Dictionary = {
	Room.Layout.A: {
		Vector2i.UP: Vector2(0, -144),
		Vector2i.DOWN: Vector2(0, 144),
		Vector2i.LEFT: Vector2(-208, 0),
		Vector2i.RIGHT: Vector2(208, 0)
	},
	Room.Layout.B: {
		Vector2i.UP: Vector2(0, -176),
		Vector2i.DOWN: Vector2(0, 176),
		Vector2i.LEFT: Vector2(-208, 0),
		Vector2i.RIGHT: Vector2(208, 0)
	}
}
