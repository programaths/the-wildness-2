tool
extends Constraint

export var target_edge:NodePath setget set_target_edge
export var color:Color=Color.red setget set_color
export var allow_same_color = false
export var required = false

func _ready():
	update()

func set_target_edge(v):
	target_edge = v
	update()

func set_color(v):
	color = v
	update()

func validate(graph:TGraph,validation_context:Dictionary):
	var validated_edge:=get_node_or_null(target_edge) as Connector
	if validated_edge!=null:
		var node_a := validated_edge.get_node_a()
		var node_b := validated_edge.get_node_b()
		if node_a && node_b && graph.contains_segment(node_a.node_number,node_b.node_number,false):
			var counts:Dictionary = validation_context.get("pass_on_edge",{})
			counts[color] = counts.get(color,0) + 1
			validation_context.pass_on_edge = counts
			return counts[color]<2 || allow_same_color
		else:
			return !required
	return false

func _draw():
	var validated_edge:=get_node_or_null(target_edge) as Connector
	if validated_edge!=null:
		var node_a := validated_edge.get_node_a()
		var node_b := validated_edge.get_node_b()
		if node_a && node_b:
			var angle = node_a.global_position.angle_to_point(node_b.global_position)
			var middle = (node_a.global_position + node_b.global_position)/2
			draw_set_transform(middle - global_position,angle,Vector2.ONE)
			draw_circle(Vector2(0,-12),4,color)
			draw_circle(Vector2(0,12),4,color)
