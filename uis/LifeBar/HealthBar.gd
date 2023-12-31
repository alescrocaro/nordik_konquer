class_name PlayerHealthBar
extends ProgressBar



########## VARS ##########
@onready var player: Player = get_node('/root/GameManager/Player/')



########## FUNCS ##########
func _ready():
	max_value = player.maxHealth
	player.healthChanged.connect(update)
	update()
#end func _ready

func update():
	value = player.currentHealth
	if value > (2*player.maxHealth/3):
		var sb = StyleBoxFlat.new()
		add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("0bfc03")
	elif value > (player.maxHealth/3) && value <= (2*player.maxHealth/3):
		var sb = StyleBoxFlat.new()
		add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("ffff00")
	elif value > 0 && value <= (player.maxHealth/3):
		var sb = StyleBoxFlat.new()
		add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("ff0d00")
	#end if
#end func update

