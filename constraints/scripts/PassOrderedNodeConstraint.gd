tool
extends Constraint

export var target_node:NodePath
export var sequence_order:int = 0 setget set_sequence_order
export var sequence_size:int = 4 setget set_sequence_size
export var bg_color:Color = Color.red setget set_bg_color

func set_sequence_order(v):
	sequence_order = v
	update()

func set_sequence_size(v):
	sequence_size = v
	update()

func set_bg_color(v):
	bg_color = v
	update()

func _ready():
	update()

func validate(graph:TGraph,validation_context:Dictionary):
	print("")
	print("validating node")
	var validated_node:=get_node_or_null(target_node) as TGraphNode
	if validated_node!=null:
		if validation_context.has("pass_ordered"):
			print("retrieving key")
			var pass_ordered = validation_context.pass_ordered
			print(pass_ordered)
			if sequence_order>=pass_ordered.seq and graph.comes_before(pass_ordered.node_number,validated_node.node_number):
				print("updating key")
				validation_context.pass_ordered = { "seq" : sequence_order,"node_number":validated_node.node_number}
				return true
			else:
				validation_context.pass_ordered = { "seq" : sequence_order,"node_number":validated_node.node_number}
				print("not matching!")
		else:
			print("setting key")
			validation_context.pass_ordered = { "seq" : sequence_order,"node_number":validated_node.node_number}
			print(validation_context.pass_ordered)
			return true
	return false

func _draw():
	var points = [Vector2(-12,-12),Vector2(12,-12),Vector2(12,12),Vector2(-12,12)]
	var smaller = [Vector2(-8,-8),Vector2(8,-8),Vector2(8,8),Vector2(-8,8)]
	var colors = []
	for i in range(4):
		colors.append(Color.darkgray.darkened(0.8))
	draw_polygon(PoolVector2Array(points),PoolColorArray(colors))
	var c :int= ceil(sqrt(sequence_size))
	if c<1:
		c=1
	colors = []
	colors.append(bg_color)
	for i in range(sequence_size):
		draw_set_transform(Vector2(i%c,floor(i/c))*6-c*Vector2.ONE*6/2+3*Vector2.ONE,0,Vector2.ONE*0.2)
		draw_polygon(PoolVector2Array(points),PoolColorArray(colors))
		if i<sequence_order:
			draw_polygon(PoolVector2Array(smaller),PoolColorArray([Color.black]))
