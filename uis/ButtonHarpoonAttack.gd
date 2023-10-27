class_name HarpoonAttackButton
extends Button



@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var cannonAttackButton: CannonAttackButton = get_node('../ButtonCannonAttack')
@onready var sniperAttackButton: SniperAttackButton = get_node('../ButtonSniperAttack')
@onready var buttonTurnLeft: ButtonTurnLeft = get_node('../TurnContainer/ButtonTurnLeft')
@onready var buttonTurnRight: ButtonTurnRight = get_node('../TurnContainer/ButtonTurnRight')
@onready var myLOG: LOG = get_node('/root/GameManager/CanvasLayer/HudManager/LOG')
@onready var skipTurnButton: ButtonSkipTurn = get_node('/root/GameManager/CanvasLayer/HudManager/ButtonSkipTurn')



func _pressed() -> void:
	if player.hasEnoughActionsLeft('HARPOON'):
		player.isAttackingWithHarpoon = true
		disableButton()
		buttonTurnRight.disableButton()
		buttonTurnLeft.disableButton()
		cannonAttackButton.disableButton()
		sniperAttackButton.disableButton()
		skipTurnButton.disableButton()
		map.setAvailableHarpoonAttacks()
	else:
		myLOG.addLOG("NOT ENOUGHT ACTIONS")
	#end ifelse
#end func _pressed

func enableButton():
	disabled = false
#func changeDisabled

func disableButton():
	disabled = true
#func changeDisabled
