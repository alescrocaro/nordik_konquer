extends Button

@onready var map: Map = get_node('/root/GameManager/Map')

func _pressed():
	print(map.tileMapDict)
	get_tree().quit()
