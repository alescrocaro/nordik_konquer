extends Button

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')

func _pressed() -> void:
	player.isAttackingWithCannon = true
	map.setAvailableCannonAttacks()
#end func _pressed
