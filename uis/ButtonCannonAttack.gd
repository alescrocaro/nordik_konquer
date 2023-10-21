extends Button

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var gameManager: GameManager = get_node('/root/GameManager')


func _ready():
	disabled = false
	player.startedAttack.connect(disableButton)
	player.finishedAttack.connect(enableButton)
	gameManager.startedPlayerTurn.connect(enableButton)
	gameManager.finishedPlayerTurn.connect(disableButton)
#end func _ready

func _pressed() -> void:
	player.isAtackingByCannon = true
	map.setAvailableCannonAtacks()
#end func _pressed

func disableButton():
	disabled = true
#end func disableButton

func enableButton():
	disabled = false
#end func _ready


