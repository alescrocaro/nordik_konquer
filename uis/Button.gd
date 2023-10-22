extends Button

@onready var map: Map = get_node('/root/GameManager/Map')
@onready var gameManager: GameManager = get_node('/root/GameManager')

func _pressed():
#	print(map.tileMapDict)
	var lista = gameManager.islandEnemies
	var result = null
	for enemy in lista:
		if enemy.type == "EnemyIsland":
			result = enemy
	print(result) 
#	print(gameManager.islandEnemies.find(teste))
	get_tree().quit()

