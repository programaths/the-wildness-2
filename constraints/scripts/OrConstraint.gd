extends Constraint

func validate(graph,validation_context):
	var is_valid = false
	var children = get_children()
	for c in children:
		if c.has_method("collect"):
			c.collect(self,validation_context)
	for c in children:
		if c is Constraint:
			print("validating:",c.name)
			print(validation_context)
			is_valid = c.validate(graph,validation_context) || is_valid
	return is_valid
