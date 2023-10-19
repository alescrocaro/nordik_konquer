extends Button

@onready var player = get_node('/root/GameManager/Player')


func _pressed() -> void:
	player.isAtacking = true
	
