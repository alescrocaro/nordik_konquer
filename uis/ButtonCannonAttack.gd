class_name CannonAttackButton
extends Button



@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var harpoonAttackButton: HarpoonAttackButton = get_node('../ButtonHarpoonAttack')
@onready var sniperAttackButton: SniperAttackButton = get_node('../ButtonSniperAttack')
@onready var buttonTurnLeft: ButtonTurnLeft = get_node('../TurnContainer/ButtonTurnLeft')
@onready var buttonTurnRight: ButtonTurnRight = get_node('../TurnContainer/ButtonTurnRight')
@onready var myLOG: LOG = get_node('/root/GameManager/CanvasLayer/HudManager/LOG')
@onready var skipTurnButton: ButtonSkipTurn = get_node('/root/GameManager/CanvasLayer/HudManager/ButtonSkipTurn')



func _pressed() -> void:
	if player.hasCannonBalls():
		if player.hasEnoughActionsLeft('CANNON'):
			player.isAttackingWithCannon = true
			disableButton()
			buttonTurnRight.disableButton()
			buttonTurnLeft.disableButton()
			harpoonAttackButton.disableButton()
			sniperAttackButton.disableButton()
			skipTurnButton.disableButton()
			map.setAvailableCannonAttacks()
		else:
			myLOG.addLOG("NOT ENOUGHT ACTIONS")
		#end ifelse
	else:
		myLOG.addLOG("OUT OF AMMO")
	#end ifelse
#end func _pressed

func enableButton():
	disabled = false
#func changeDisabled

func disableButton():
	disabled = true
#func changeDisabled
