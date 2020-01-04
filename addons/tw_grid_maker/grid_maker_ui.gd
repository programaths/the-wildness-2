tool
extends Control

onready var button = $GridContainer/Button
onready var edi = EditorInterface.new()
onready var cols = $GridContainer/SpinBox2
onready var rows = $GridContainer/SpinBox
onready var spacing = $GridContainer/SpinBox3

signal create_nodes(rows,cols,spacing)

func _ready():
	button.connect("pressed",self,"create_nodes")

func create_nodes():
	emit_signal("create_nodes",rows.value,cols.value,spacing.value)
