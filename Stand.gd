extends Spatial

onready var viewport = $StaticBody/Viewport_quad/Viewport
func _ready():
	# Get the viewport and clear it
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)

	# Let two frames pass to make sure the vieport's is captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# Retrieve the texture and set it to the viewport quad
	get_node("StaticBody/Viewport_quad").material_override.albedo_texture = viewport.get_texture()

	
