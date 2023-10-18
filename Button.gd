extends Button

@onready var tileMap = get_node('/root/GameManager/Map')

func _pressed():
	get_tree().quit()
