extends Label

@onready var player: Player = get_node('/root/GameManager/Player')

# Called when the node enters the scene tree for the first time.
func _ready():
	if player.currentTile.warningAmount > 0:
		visible = true
		player.combatMode = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.currentTile.warningAmount > 0 && !visible:
		visible = true
		player.combatMode = true
	elif player.currentTile.warningAmount < 1 && visible:
		visible = false
		player.combatMode = false
