extends ProgressBar

@onready var player: Player = get_node('/root/GameManager/Player/')

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player)
	player.healthChanged.connect(update)
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update():
	value = player.currentHealth * 100 / player.maxHealth
