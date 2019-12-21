extends Viewport

func _ready():
	set_process_input(true)

func _input(event):
	print("some input")
	input(event)
