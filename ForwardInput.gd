extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var viewport = $Viewport_quad/Viewport
var prev_pos = null
var last_click_pos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func activate(click_pos):
	# Use click pos (click in 3d space, convert to area space)
	var pos = get_global_transform().affine_inverse()
	# the click pos is not zero, then use it to convert from 3D space to area space
	
	pos *= click_pos
	last_click_pos = click_pos
  
	# Convert to 2D
	pos = Vector2(pos.x, pos.y)
  
	# Convert to viewport coordinate system
	# Convert pos to a range from (0 - 1)
	pos.y *= -1
	pos += Vector2(1, 1)
	pos = pos / 2
  
	# Convert pos to be in range of the viewport
	pos.x *= viewport.size.x
	pos.y *= viewport.size.y
	
	# Set the position in event
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
