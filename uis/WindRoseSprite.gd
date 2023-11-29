class_name WindRose
extends Sprite2D


func changeFrame(windDirection):
	match windDirection:
		'N':
			frame = 4
		'L':
			frame = 1
		'S':
			frame = 2
		'O':
			frame = 3
		_:
			frame = 0
