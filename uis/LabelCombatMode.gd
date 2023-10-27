extends Label

@onready var player: Player = get_node('/root/GameManager/Player')

func _ready():
	if player.currentTile.warningAmount > 0:
		visible = true
		player.combatMode = true
	#end if
#end func _ready


func _process(_delta):
	if player.currentTile.warningAmount > 0 && !visible:
		visible = true
		player.combatMode = true
	elif player.currentTile.warningAmount < 1 && visible:
		visible = false
		player.combatMode = false
	#end ifelse
#end func _process
