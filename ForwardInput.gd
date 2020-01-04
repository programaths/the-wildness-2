extends CollisionObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var viewport = $Viewport_quad/Viewport
onready var viewport_quad = $Viewport_quad
export var quad_size = Vector2(1,1)

var prev_pos = null
var last_click_pos = null
signal puzzle_dot_position_changed(dot_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func activate(click_pos):
	print("activate ",click_pos)
	var pos = viewport_quad.global_transform.xform_inv(click_pos)
	print("unprojected pos", pos)
	last_click_pos = click_pos
	pos = Vector2(pos.x, pos.y)
	pos.y *= -1
	pos /= quad_size
	pos += Vector2(0.5, 0.5)
	print("normalized: ",pos)
	pos.x *= viewport.size.x
	pos.y *= viewport.size.y
	var event = InputEventMouseButton.new()
	event.pressed = true
	event.button_index = BUTTON_LEFT
	event.position = pos
	event.global_position = pos
	if not prev_pos:
		prev_pos = pos
	prev_pos = pos
	print(event.position)
	# Send the event to the viewport
	viewport.input(event)

func move_line(rel_move):
	var event = InputEventMouseMotion.new()
	event.relative=rel_move
	viewport.input(event)


func _input(event):
	if event is InputEventKey:
		viewport.input(event)

var nb=0

func _on_Puzzle_dot_position_changed(dot_position):
	nb = nb + 1
	if nb>20:
		print("dot pos 2D: ",dot_position)
	dot_position.x /= viewport.size.x
	dot_position.y /= viewport.size.y
	dot_position -= Vector2(0.5,0.5)
	dot_position *= quad_size
	dot_position.y *= -1
	dot_position = Vector3(dot_position.x,dot_position.y,0)
	dot_position = viewport_quad.global_transform.xform(dot_position)
	if nb>20:
		print("dot pos 3D: ",dot_position)
		nb = 0
	emit_signal("puzzle_dot_position_changed",dot_position)
