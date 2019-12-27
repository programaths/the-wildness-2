tool
extends Constraint

export var target_node:NodePath

func _ready():
	update()

func validate(graph:TGraph,_d:Dictionary):
	var validated_node:=get_node_or_null(target_node) as TGraphNode
	if validated_node!=null:
		return graph.contains_node(validated_node.node_number)
	return false

func _draw():
	var points = []
	var colors = []
	
	for i in range(6):
		points.append(Vector2(sin(TAU/6*i),cos(TAU/6*i))*12)
		colors.append(Color.darkgray.darkened(0.8))
	draw_polygon(PoolVector2Array(points),PoolColorArray(colors))
