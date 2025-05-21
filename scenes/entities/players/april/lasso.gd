extends Line2D


func _process(_delta):
	var joint_positions = []
	var pin_joints = get_children().filter(func (c): return c is PinJoint2D)
	
	for joint in pin_joints:
		joint_positions.append(joint.global_position)
	
	var smooth_points = catmull_rom_spline(joint_positions)
	points = smooth_points


func catmull_rom_spline(
	_points: Array, resolution: int = 10, extrapolate_end_points = true
	) -> PackedVector2Array:
	var input_points = _points.duplicate()
	if extrapolate_end_points:
		input_points.insert(0, input_points[0] - (input_points[1] - input_points[0]))
		input_points.append(input_points[-1] + (input_points[-1] - input_points[-2]))
	
	var smooth_points := PackedVector2Array()
	if input_points.size() < 4:
		return input_points
	
	for i in range(1, input_points.size() - 2):
		var p0 = input_points[i - 1]
		var p1 = input_points[i]
		var p2 = input_points[i + 1]
		var p3 = input_points[i + 2]
		
		for t in range(0, resolution):
			var tt = t / float(resolution)
			var tt2 = tt * tt
			var tt3 = tt2 * tt
			
			var q = (
				0.5
				* (
					(2.0 * p1)
					+ (-p0 + p2) * tt
					+ (2.0 * p0 - 5.0 * p1 + 4 * p2 - p3) * tt2
					+ (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * tt3
				)
			)
			
			smooth_points.append(q)
	
	return smooth_points
