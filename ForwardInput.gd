extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var viewport = $Viewport


export var main_camera_path:NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)



func _input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		var camera:Camera = get_node(main_camera_path) as Camera
		var space_state : BulletPhysicsDirectSpaceState = get_world().direct_space_state
		var from= camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position)*10000
		var isect = space_state.intersect_ray(from,to)
		if isect and isect.collider==get_parent():
			var mouse_pos = Vector2((isect.position-global_transform.origin).dot(global_transform.basis.x)*512+512,(isect.position-global_transform.origin).dot(global_transform.basis.y)*-300+300)
			event.global_position = mouse_pos
			event.position = mouse_pos
			viewport.input(event)



	
	
