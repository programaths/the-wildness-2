extends Constraint

export var count:int=0
enum COMPARISON_TYPE {EQUAL,LESS,MORE,LEQ,GEQ,NEQ}
export(COMPARISON_TYPE) var comparison

func validate(graph:TGraph,validation_context:Dictionary):
	var children = get_children()
	var nb_valid = 0
	for c in children:
		if c.has_method("collect"):
			c.collect(self,validation_context)
	for c in children:
		if c is Constraint:
			print("validating:",c.name)
			print(validation_context)
			if c.validate(graph,validation_context):
				nb_valid += 1
	match comparison:
		COMPARISON_TYPE.EQUAL:
			return nb_valid == count
		COMPARISON_TYPE.NEQ:
			return nb_valid != count
		COMPARISON_TYPE.LESS:
			return nb_valid < count
		COMPARISON_TYPE.MORE:
			return nb_valid > count
		COMPARISON_TYPE.GEQ:
			return nb_valid >= count
		COMPARISON_TYPE.LEQ:
			return nb_valid <= count
	return false
