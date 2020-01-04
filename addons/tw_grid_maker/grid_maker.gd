tool
extends EditorPlugin

# A class member to hold the dock during the plugin lifecycle
var dock

func _enter_tree():
	# Initialization of the plugin goes here
	# Load the dock scene and instance it
	dock = preload("res://addons/tw_grid_maker/grid_maker.tscn").instance()
	dock.connect("create_nodes",self,"create_nodes")

	# Add the loaded scene to the docks
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock

func name_node_AAZZ(n):
	var name = ""
	n = int(n)
	if n==0:
		return "A"
	while n>0:
		name = char(65+n%26) + name
		n=int(n/26)
	return name

func create_nodes(rows,cols,spacing):
	print("creating nodes")
	var root = get_editor_interface().get_edited_scene_root()
	var vc:Dictionary = {}
	var cons = []
	for r in range(rows):
		for c in range(cols):
			var node = TGraphNode.new()
			node.node_number = r*cols + c
			node.name = name_node_AAZZ(node.node_number)
			root.add_child(node)
			node.owner = root
			node.position = Vector2(c*spacing,r*spacing)
			vc[Vector2(c,r)] = node
			var up = vc.get(Vector2(c,r-1))
			var left = vc.get(Vector2(c-1,r))
			if up:
				var con = Connector.new()
				con.name = node.name + "_" + up.name
				root.add_child(con)
				con.owner = root
				con.nodePathA = con.get_path_to(up)
				con.nodePathB = con.get_path_to(node)
				cons.append(con)
			if left:
				var con = Connector.new()
				con.name = node.name + "_" + left.name
				root.add_child(con)
				con.owner = root
				con.nodePathA = con.get_path_to(left)
				con.nodePathB = con.get_path_to(node)
				cons.append(con)
	for con in cons:
		root.move_child(con,0)

func _exit_tree():
	# Clean-up of the plugin goes here
	# Remove the dock
	remove_control_from_docks(dock)
	 # Erase the control from the memory
	dock.free()
