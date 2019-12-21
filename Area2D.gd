extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered",self,"mouse_in")
	pass # Replace with function body.

func mouse_in():
	print("ok")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
