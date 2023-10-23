extends Label

@onready var gameManager: GameManager = get_node('/root/GameManager')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "ACTIONS: " + str(gameManager.actions)
