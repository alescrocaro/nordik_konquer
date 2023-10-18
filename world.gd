extends Node2D

@onready var Map = $"./Map"
@onready var DesertIsland = preload("res://Islands/DesertIsland.tscn")
@onready var EnemyIsland = preload("res://Islands/EnemyIsland.tscn")

@export var desertIslandAmount: int = 7
@export var enemyIslandAmount: int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	generateDesertIslands()
	generateEnemyIslands()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass

func generateDesertIslands() -> void:
	var desertIslandCount: int = 0
	var desertIslandCountIterations: int = 0

	while true:
		desertIslandCountIterations += 1
		if desertIslandCount >= desertIslandAmount:
			break
		#end if

		if (desertIslandCountIterations >= 3 * desertIslandAmount):
			return
		#end if

		var desertIslandTile = Map.getRandomTile()

		if (desertIslandCount > 0 && Map.isNear(5, 'DesertIsland', desertIslandTile) && desertIslandCountIterations < 3 * desertIslandAmount):
			continue
		#end if

		if Map.tileMapDict[str(desertIslandTile.gridPosition)].type == 'Ocean':
			desertIslandCount += 1
			Map.tileMapDict[str(desertIslandTile.gridPosition)].type = 'DesertIsland'

			var desertIslandInstance = DesertIsland.instantiate()
			desertIslandInstance.position = desertIslandTile.globalPosition

			get_node('./Islands').add_child(desertIslandInstance)
		#end if
	#end while
#end func generateDesertIslands

func generateEnemyIslands() -> void:
	var enemyIslandCount: int = 0
	var enemyIslandCountIterations: int = 0

	while true:
		if enemyIslandCount >= enemyIslandAmount:
			break
		#end if

		if (enemyIslandCountIterations >= 3 * enemyIslandAmount):
			return
		#end if

		var enemyIslandTile = Map.getRandomTile()

		if (enemyIslandCount > 0 && Map.isNear(6, 'EnemyIsland', enemyIslandTile) && enemyIslandCountIterations < 3 * enemyIslandAmount):
			continue
		#end if

		if Map.tileMapDict[str(enemyIslandTile.gridPosition)].type == 'Ocean':
			enemyIslandCount += 1
			Map.tileMapDict[str(enemyIslandTile.gridPosition)].type = 'EnemyIsland'

			var enemyIslandInstance = EnemyIsland.instantiate()
			enemyIslandInstance.position = enemyIslandTile.globalPosition

			get_node('./Islands').add_child(enemyIslandInstance)
#end func generateEnemyIslands
