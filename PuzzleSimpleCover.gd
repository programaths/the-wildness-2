extends Position3D

onready var ap = $AnimationPlayer


func _on_Puzzle1_solved():
	ap.play("Open")


func _on_Puzzle1_unsolved():
	ap.play("Close")
