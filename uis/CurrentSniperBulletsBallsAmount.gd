class_name CurrentSniperBulletsAmount
extends Label



@onready var player: Player = get_node('/root/GameManager/Player')



func _ready():
	text = str(player.maxSniperBulletsAmount)
#end func _ready

func setText(newText: String) -> void:
	print('setting sniper bullets', newText)
	text = newText
#end func setText
