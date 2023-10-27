class_name HarpoonAttackButton
extends Button

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var cannonAttackButton: CannonAttackButton = get_node('../ButtonCannonAttack')
@onready var sniperAttackButton: SniperAttackButton = get_node('../ButtonSniperAttack')
@onready var buttonTurnLeft: ButtonTurnLeft = get_node('../TurnContainer/ButtonTurnLeft')
@onready var buttonTurnRight: ButtonTurnRight = get_node('../TurnContainer/ButtonTurnRight')

func _pressed() -> void:
	player.isAttackingWithHarpoon = true
	disableButton()
	buttonTurnRight.disableButton()
	buttonTurnLeft.disableButton()
	cannonAttackButton.disableButton()
	sniperAttackButton.disableButton()
	map.setAvailableHarpoonAttacks()
#end func _pressed

func enableButton():
	disabled = false
#func changeDisabled

func disableButton():
	disabled = true
#func changeDisabled
