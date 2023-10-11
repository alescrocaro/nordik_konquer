extends Button

@onready var player = get_node('/root/GameManager/Player')
@onready var playerSprite: Sprite2D = get_node('/root/GameManager/Player/playerSprite')


func _pressed() -> void:
	var currentFrame = playerSprite.get_frame()
	playerSprite.set_frame(currentFrame - 1 if currentFrame > 0 else 3)
	
	
