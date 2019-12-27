extends KinematicBody

onready var pivot = $Pivot
onready var camera = $Pivot/Camera
class_name Player

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var mouse_h_vel = 0
const MOUSE_SENSITIVITY = 0.05
var dir = Vector3()

var solving_puzzle = false

var puzzle = null

func _input(event):
	if not solving_puzzle:
			if event is InputEventMouseMotion:
				self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
				camera.rotate_x(deg2rad(event.relative.y*MOUSE_SENSITIVITY*-1))
				camera.rotation_degrees.x=clamp(camera.rotation_degrees.x,-70,70)
	if event is InputEventKey and event.pressed and event.scancode==KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		var space_state : BulletPhysicsDirectSpaceState = get_world().direct_space_state
		var from= camera.project_ray_origin(event.global_position)
		var to = from + camera.project_ray_normal(event.global_position)*10000
		var isect = space_state.intersect_ray(from,to,[self],1,true,true)
		if isect and isect.collider.has_method("activate"):
			print(isect)
			isect.collider.activate(isect.position)
			puzzle = isect.collider
	if solving_puzzle and puzzle:
		if event is InputEventMouseMotion:
			puzzle.move_line(event.relative)

func _process(delta):
	if solving_puzzle:
		return
	dir=Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()
	if Input.is_action_pressed("forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("left"):
		input_movement_vector.x -=1
	if Input.is_action_pressed("right"):
		input_movement_vector.x +=1
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	dir.y = -1
	var speed = 5
	if Input.is_action_pressed("run"):
		speed = 10
	if test_move(transform.translated(Vector3.DOWN),dir*speed+Vector3.DOWN*3*speed/5):
		move_and_slide_with_snap(dir*speed,Vector3.DOWN*10*speed/5,Vector3.UP,true)

func get_camera():
	return camera

func _on_Puzzle_end_solving():
	solving_puzzle = false
	


func _on_Puzzle_start_solving():
	solving_puzzle = true
	




func _on_Puzzle0_start_solving():
	pass # Replace with function body.
