extends Node2D

var astar:Pathing2D
var current_position = Vector2()
var relative_motion = Vector2()

var path = []
var last_point = 0
var start_ids=[]
var end_ids=[]
var bounds = {
		"a":{
			"id": -1,
			"position": Vector2(0,0)
		},
		"b":{
			"id": -1,
			"position": Vector2(0,0)
		},
		"p":Vector2(0,0)
	}

var is_solved = false
var active = false

signal solved
signal unsolved
signal start_solving
signal end_solving

const size_factor = 2

func _ready():
	astar=Pathing2D.new()
	for node in get_children():
		if node is TGraphNode:
			astar.add_point(node.node_number,node.position)
			if node.point_type==1:
				start_ids.push_back(node.node_number)
			if node.point_type==2:
				end_ids.push_back(node.node_number)
	for node in get_children():
		if node is Connector:
			var nodeA:Position2D=node.get_node(node.nodePathA)
			var nodeB:Position2D=node.get_node(node.nodePathB)
			astar.connect_points(nodeA.node_number,nodeB.node_number)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not active: return
	var previous_position = current_position
	current_position = current_position+relative_motion.clamped(10)
	relative_motion = Vector2()
	bounds = astar.get_segment_bounds(current_position)
	if !path.empty():
		if bounds.a.id!=path.back() and bounds.b.id!=path.back():
			current_position = previous_position
			return
	var going_to=astar.moving_toward(previous_position,current_position,bounds.a,bounds.b)
	if !path.empty() and path.has(going_to.to.id) and path.back()!=going_to.to.id and current_position.distance_to(going_to.to.position)<20:
		current_position = previous_position
		return
	current_position = bounds.p
	if !path.empty():
		if !path.has(going_to.to.id) and current_position.distance_to(going_to.to.position)<10:
			path.push_back(going_to.to.id)
		if path.size()>1:
			if path[path.size()-2]==going_to.to.id and path[path.size()-1]==going_to.from.id:
				path.pop_back()
			pass
#	print(path)
	update()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_LEFT:
			if event.pressed:
				if active:
					var pt = astar.get_closest_point(current_position)
					if pt in end_ids:
						if astar.get_point_position(pt).distance_to(current_position)<4:
							is_solved = true
							emit_signal("solved")
							emit_signal("end_solving")
							var vp_camera = get_tree().root.get_camera()
							get_viewport().warp_mouse(current_position)
							active = false
				else:
					var pt = astar.get_closest_point(event.position)
					if pt in start_ids and not active and astar.get_point_position(pt).distance_to(event.position)<50:
						if is_solved:
							is_solved = false
							emit_signal("unsolved")
						path = [pt]
						last_point=pt
						current_position = astar.get_point_position(pt)
						active = true
						emit_signal("start_solving")
		else:
			if !path.empty():
				get_viewport().warp_mouse(astar.get_point_position(path.front()))
			if is_solved:
				is_solved = false
				emit_signal("unsolved")
			path = []
			last_point = 0
			active = false
			emit_signal("end_solving")
			update()
	if event is InputEventMouseMotion:
		relative_motion = event.relative
	if event is InputEventKey and Input.is_key_pressed(KEY_ESCAPE):
		if !path.empty():
			get_viewport().warp_mouse(astar.get_point_position(path.front()))
		if not is_solved:
			is_solved = false
			emit_signal("unsolved")
		path = []
		last_point = 0
		active = false
		emit_signal("end_solving")
		update()
		

func _draw():
	for s in astar.segments():
		draw_line(astar.get_point_position(s[0]),astar.get_point_position(s[1]),Color.gray,4*size_factor)
		draw_circle(astar.get_point_position(s[0]),2*size_factor,Color.gray)
		draw_circle(astar.get_point_position(s[1]),2*size_factor,Color.gray)
#	draw_circle(current_position,20,Color.white)
#	draw_circle(bounds[3],10,Color.red)
	if !path.empty():
		var path_points = []
		for p in path:
			path_points.push_back(astar.get_point_position(p))
		path_points.push_back(current_position)
		if path.size()>0:
			var previous_point = path_points[0]
			for p in path_points:
				draw_line(previous_point,p,Color.white,8.0*size_factor,true)
				draw_circle(p,4.0*size_factor,Color.white)
				previous_point = p
		#draw_polyline(PoolVector2Array(path_points),Color.white,8.0,true)
