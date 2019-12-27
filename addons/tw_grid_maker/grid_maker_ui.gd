tool
extends Control

onready var button = $GridContainer/Button
onready var edi = EditorInterface.new()
onready var cols = $GridContainer/SpinBox2

func _ready():
	button.connect("pressed",self,"create_nodes")

func create_nodes():
	print("adding node")
	var node = Node2D.new()
	node.owner = edi.get_edited_scene_root()
	edi.get_edited_scene_root().add_child(node)
	cols.value = 0
