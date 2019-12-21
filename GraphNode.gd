tool
extends Position2D

class_name TGraphNode

export(int) var node_number=0
export(int,"NONE","START","END") var point_type = 0

var font

func _ready():
	var label = Label.new()
	font = label.get_font("")
	label.queue_free()

func _process(delta):
	update()

func _draw():
	if point_type==1:
		draw_circle(Vector2(),16,Color.white)
	if Engine.editor_hint:
		draw_set_transform(Vector2(),0,Vector2(2,2))
		draw_string(font,Vector2(),name,Color.black)
	
