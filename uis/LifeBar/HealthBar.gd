extends ProgressBar


########## VARS ##########
@onready var player: Player = get_node('/root/GameManager/Player/')



########## FUNCS ##########
func _ready():
	print(player)
	player.healthChanged.connect(update)
	update()

func update():
	value = player.currentHealth * 100 / player.maxHealth
