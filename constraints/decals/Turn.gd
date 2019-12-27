tool
extends Node2D

export var top_left:Color=Color.black setget set_tl
export var top_right:Color=Color.black setget set_tr
export var down_left:Color=Color.black setget set_dl
export var down_right:Color=Color.black setget set_dr

func set_tl(v):
	top_left = v
	update()

func set_tr(v):
	top_right = v
	update()

func set_dl(v):
	down_left = v
	update()

func set_dr(v):
	down_right = v
	update()

func _draw():
	draw_rect(Rect2(-8,-8,16,16),Color.gray)
	draw_circle(Vector2(-8,-8),4,top_left)
	draw_circle(Vector2(8,-8),4,top_right)
	draw_circle(Vector2(-8,8),4,down_left)
	draw_circle(Vector2(8,8),4,down_right)
