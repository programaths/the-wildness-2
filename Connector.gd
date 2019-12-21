tool
extends Position2D

class_name Connector

export(NodePath) var nodePathA:NodePath
export(NodePath) var nodePathB:NodePath

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Engine.editor_hint:
		update()
	pass

func _draw():
	if Engine.editor_hint:
		var nodeA:Position2D=get_node_or_null(nodePathA)
		var nodeB:Position2D=get_node_or_null(nodePathB)
		if nodeA and nodeB:
			draw_line(nodeA.position,nodeB.position,Color.white,8)
