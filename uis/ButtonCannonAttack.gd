class_name CannonAttackButton
extends Button

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var harpoonAttackButton: HarpoonAttackButton = get_node('../ButtonHarpoonAttack')
@onready var sniperAttackButton: SniperAttackButton = get_node('../ButtonSniperAttack')
@onready var buttonTurnLeft: ButtonTurnLeft = get_node('../TurnContainer/ButtonTurnLeft')
@onready var buttonTurnRight: ButtonTurnRight = get_node('../TurnContainer/ButtonTurnRight')

func _pressed() -> void:
	player.isAttackingWithCannon = true
	disableButton()
	buttonTurnRight.disableButton()
	buttonTurnLeft.disableButton()
	harpoonAttackButton.disableButton()
	sniperAttackButton.disableButton()
	map.setAvailableCannonAttacks()
#end func _pressed

func enableButton():
	disabled = false
#func changeDisabled

func disableButton():
	disabled = true
#func changeDisabled
