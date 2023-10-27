class_name ButtonSkipTurn
extends Button



@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var player: Player = get_node('/root/GameManager/Player')



func _pressed():
	player.doAction.emit(777)
#end func _pressed

func enableButton():
	disabled = false
#func changeDisabled

func disableButton():
	disabled = true
#func changeDisabled
