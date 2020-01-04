tool
extends Node2D

export(int,1,6) var count = 2

func _process(delta):
	update()

func _draw():
	var triangle = PoolVector2Array()
	for i in range(3):
		triangle.append(Vector2(sin(TAU/3*i+TAU/2)*8,cos(TAU/3*i+TAU/2)*8))
	if count==1:
		draw_polygon(triangle,PoolColorArray([Color.yellow]))
	else:
		for i in range(count):
			draw_set_transform(Vector2(sin(TAU/count*i+TAU/2)*(8+count),cos(TAU/count*i+TAU/2)*(8+count)),0,Vector2.ONE)
			draw_polygon(triangle,PoolColorArray([Color.yellow]))
