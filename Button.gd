extends Button

@onready var tileMap = get_node('/root/GameManager/Map')

func _pressed():
	print(tileMap.tileMapDict)
	get_tree().quit()
