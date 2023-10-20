extends ProgressBar

@onready var this_node: EnemyIsland = $"../.."
@onready var label: Label = $"./Label"

func _ready():
	max_value = this_node.maxHealth
	this_node.healthChanged.connect(update)
	update()
#end func _ready

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update():
	value = this_node.currentHealth
	label.set_text(str(this_node.currentHealth))
	if value > (2*this_node.maxHealth/3):
		var sb = StyleBoxFlat.new()
		add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("0bfc03")
	elif value > (this_node.maxHealth/3) && value <= (2*this_node.maxHealth/3):
		var sb = StyleBoxFlat.new()
		add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("ffff00")
	elif value > 0 && value <= (this_node.maxHealth/3):
		var sb = StyleBoxFlat.new()
		add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("ff0d00")
#end func update

