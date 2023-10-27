class_name SniperAttackButton
extends Button

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var cannonAttackButton: CannonAttackButton = get_node('../ButtonCannonAttack')
@onready var harpoonAttackButton: HarpoonAttackButton = get_node('../ButtonHarpoonAttack')
@onready var buttonTurnLeft: ButtonTurnLeft = get_node('../TurnContainer/ButtonTurnLeft')
@onready var buttonTurnRight: ButtonTurnRight = get_node('../TurnContainer/ButtonTurnRight')

func _pressed() -> void:
	player.isAttackingWithSniper = true
	disableButton()
	buttonTurnRight.disableButton()
	buttonTurnLeft.disableButton()
	cannonAttackButton.disableButton()
	harpoonAttackButton.disableButton()
	map.setAvailableSniperAttacks()
#end func _pressed

func enableButton():
	disabled = false
#func changeDisabled

func disableButton():
	disabled = true
#func changeDisabled
