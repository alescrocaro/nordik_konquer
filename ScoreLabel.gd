class_name PlayerScore
extends Label

########## VARS ##########
@onready var player: Player = get_node('/root/GameManager/Player/')



########## FUNCS ##########
func _ready():
	player.scoreChanged.connect(update)
	text = str(player.score)
#end func _ready

func update():
	text = str(player.score)
#end func update

