extends AStar2D
class_name Pathing2D

var astar = AStar2D.new()

func get_segment_bounds(position:Vector2):
	var point = get_closest_position_in_segment(position)
	var segs = segments()
	var min_points = {
		"a":{
			"id": -1,
			"position": Vector2(0,0)
		},
		"b":{
			"id": -1,
			"position": Vector2(0,0)
		},
		"p":point
	}
	var minDistance = 10000
	for seg in segs:
		var point_a = get_point_position(seg[0])
		var point_b = get_point_position(seg[1])
		if Geometry.get_closest_point_to_segment_2d(position,point_a,point_b).distance_squared_to(point)<minDistance:
			minDistance = Geometry.get_closest_point_to_segment_2d(position,point_a,point_b).distance_squared_to(point)
			var min_point = point_b
			var min_point_id = seg[1]
			var max_point = point_a
			var max_point_id = seg[0]
			if point_a.distance_squared_to(point)<point_b.distance_squared_to(point):
				min_point = point_a
				min_point_id = seg[0]
				max_point = point_b
				max_point_id = seg[1]
			min_points= {
				"a":{
					"id": min_point_id,
					"position": min_point
				},
				"b":{
					"id": max_point_id,
					"position": max_point
				},
				"p":point
			}
	return min_points

static func moving_toward(previous:Vector2,current:Vector2,a:Dictionary,b:Dictionary):
	if (b.position-a.position).dot((current-previous)) > 0:
		return {"from":a,"to":b}
	return {"from":b,"to":a}

func segments():
	var points = get_points()
	if points.size()<2:
		return []
	var segs = []
	for i in range(0,points.size()):
		for j in range(i+1,points.size()):
			if .are_points_connected(points[i],points[j]):
				segs.push_back([points[i],points[j]])
	return segs
