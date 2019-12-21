extends Position3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("forward"):
		translate_object_local(Vector3.FORWARD*delta*2)
	if Input.is_action_pressed("backward"):
		translate_object_local(Vector3.BACK*delta*2)
	if Input.is_action_pressed("left"):
		rotate_object_local(Vector3.UP,TAU/4*delta)
	if Input.is_action_pressed("right"):
		rotate_object_local(Vector3.UP,-TAU/4*delta)
	if Input.is_action_pressed("straff_left"):
		translate_object_local(Vector3.LEFT*delta*2)
	if Input.is_action_pressed("straff_right"):
		translate_object_local(Vector3.RIGHT*delta*2)
