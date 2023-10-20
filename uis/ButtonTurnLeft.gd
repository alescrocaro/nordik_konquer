extends Button

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var playerSprite: Sprite2D = get_node('/root/GameManager/Player/playerSprite')


func _ready():
	disabled = false
	player.startedAttack.connect(disableButton)
	player.finishedAttack.connect(enableButton)
#end func _ready

func _pressed() -> void:
	var currentFrame = playerSprite.get_frame()
	playerSprite.set_frame(currentFrame + 1 if currentFrame < 3 else 0)
#end func _pressed

func disableButton():
	disabled = true
#end func disableButton

func enableButton():
	disabled = false
#end func _ready
