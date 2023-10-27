extends Label

@onready var gameManager: GameManager = get_node('/root/GameManager')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "ACTIONS: " + str(gameManager.actions)
#end func _process
