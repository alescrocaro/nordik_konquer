class_name ButtonTurnRight
extends Button

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var playerSprite: Sprite2D = get_node('/root/GameManager/Player/playerSprite')

func _pressed() -> void:
	player.handleRotate('right')
#end func _pressed

func disableButton():
	disabled = true
#end func disableButton

func enableButton():
	disabled = false
#end func enableButton
