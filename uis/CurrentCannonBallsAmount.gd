class_name CurrentCannonBallsAmount
extends Label



@onready var player: Player = get_node('/root/GameManager/Player')



func _ready():
	text = str(player.maxCannonBallsAmount)
#end func _ready

func setText(newText: String) -> void:
	text = newText
#end func setText
