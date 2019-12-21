tool
extends Node2D


onready var a = $A
onready var b = $B
onready var c = $C
onready var d = $D
onready var e = $E
onready var f = $F
onready var g = $G
onready var h = $H

var astar:Pathing2D
var current_position = Vector2()
var relative_motion = Vector2()

var path = []
var last_point = 0
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

func _ready():
	astar=Pathing2D.new()
	astar.add_point(0,a.position)
	astar.add_point(1,b.position)
	astar.add_point(2,c.position)
	astar.add_point(3,d.position)
	astar.add_point(4,e.position)
	astar.add_point(5,f.position)
	astar.add_point(6,g.position)
	astar.add_point(7,h.position)
	astar.connect_points(0,1)
	astar.connect_points(1,2)
	astar.connect_points(1,3)
	astar.connect_points(3,4)
	astar.connect_points(2,5)
	astar.connect_points(4,5)
	astar.connect_points(5,6)
	astar.connect_points(6,7)
	astar.connect_points(2,7)
	current_position = a.position
	path.append(0)

func _process(delta):
	if Engine.editor_hint:
		update()
		return
	if Input.get_mouse_mode()!=Input.MOUSE_MODE_CAPTURED: return
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
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		relative_motion = event.relative
	if event is InputEventKey and Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _draw():
	for s in astar.segments():
		draw_line(astar.get_point_position(s[0]),astar.get_point_position(s[1]),Color.gray,4)
	if Engine.editor_hint:
		return
#	draw_line(a.position,b.position,Color.gray,4)
#	draw_line(b.position,c.position,Color.gray,4)
#	draw_line(b.position,d.position,Color.gray,4)
#	draw_line(d.position,e.position,Color.gray,4)
#	draw_line(e.position,f.position,Color.gray,4)
#	draw_line(f.position,c.position,Color.gray,4)
#	draw_line(f.position,g.position,Color.gray,4)
#	draw_line(g.position,h.position,Color.gray,4)
#	draw_line(h.position,c.position,Color.gray,4)
	
#	draw_line(bounds[0],bounds[2],Color.red)
	draw_circle(current_position,20,Color.white)
#	draw_circle(bounds[3],10,Color.red)
	if !path.empty():
		var path_points = []
		for p in path:
			path_points.push_back(astar.get_point_position(p))
		path_points.push_back(current_position)
		if path.size()>0:
			var previous_point = path_points[0]
			for p in path_points:
				draw_line(previous_point,p,Color.white,16.0,true)
				draw_circle(p,8.0,Color.white)
				previous_point = p
		#draw_polyline(PoolVector2Array(path_points),Color.white,8.0,true)
