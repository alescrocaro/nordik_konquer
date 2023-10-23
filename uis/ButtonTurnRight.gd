extends Button

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var playerSprite: Sprite2D = get_node('/root/GameManager/Player/playerSprite')
@onready var gameManager: GameManager = get_node('/root/GameManager')

func _ready():
	disabled = false
	player.startedAttack.connect(disableButton)
	player.finishedAttack.connect(enableButton)
	gameManager.startedPlayerTurn.connect(enableButton)
	gameManager.finishedPlayerTurn.connect(disableButton)
#end func _ready

func _process(_delta):
	if gameManager.isPlayerTurn && disabled: #anti bug
		disabled = false
#end func _process

func _pressed() -> void:
	player.handleRotate('right')
#end func _pressed

func disableButton():
	disabled = true
#end func disableButton

func enableButton():
	disabled = false
#end func _ready
