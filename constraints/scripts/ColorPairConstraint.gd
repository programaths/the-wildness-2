tool
extends Constraint

export var target_node:NodePath
export var color: Color = Color.red setget set_color

var valid = true

func set_color(v):
	color=v
	update()


func collect_path(idx:int,validation_context:Dictionary):
	var pass_color_pair :Array = validation_context.get("pass_color_pair",[])
	var validated_node = get_node(target_node) as TGraphNode
	if validated_node:
		if pass_color_pair.size()%2==1:
			valid = color == pass_color_pair.back()
		else:
			valid = true
		pass_color_pair.append(color)
		validation_context.pass_color_pair=pass_color_pair
	else:
		push_warning("Validated node is not found")
		valid = false

func validate(graph:TGraph,validation_context:Dictionary):
	var validated_node = get_node(target_node) as TGraphNode
	if validated_node:
		return valid && graph.contains_node(validated_node.node_number) && validation_context.get("pass_color_pair",[]).size()%2==0
	else:
		push_warning("Validated node is not found")
		return false
	


func _draw():
	draw_set_transform(Vector2(0,0),TAU/8,Vector2.ONE)
	draw_rect(Rect2(Vector2(-4,-4),Vector2(8,8)),color)
