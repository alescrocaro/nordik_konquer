class_name WindRose
extends Sprite2D


func changeFrame(windDirection):
	match windDirection:
		'N':
			frame = 1
		'L':
			frame = 2
		'S':
			frame = 3
		'O':
			frame = 4
		_:
			frame = 0
