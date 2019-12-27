extends Constraint

export var target_node:NodePath
export var in_node:NodePath
export var out_node:NodePath
export var required:bool=false

func validate(graph:TGraph,validation_context:Dictionary):
	var validated_node:=get_node_or_null(target_node) as TGraphNode
	var validated_in:=get_node_or_null(in_node) as TGraphNode
	var validated_out:=get_node_or_null(out_node) as TGraphNode
	if validated_node && validated_in && validated_out:
		if not required && not graph.contains_node(validated_node.node_number):
			return true
		return graph.contains_segment(validated_in.node_number,validated_node.node_number) && graph.contains_segment(validated_node.node_number,validated_out.node_number)
	return false
