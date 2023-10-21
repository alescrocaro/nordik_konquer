class_name Map
extends TileMap

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var desertIsland = preload("res://Islands/DesertIsland.tscn")
@onready var enemyIsland = preload("res://Islands/EnemyIsland.tscn")

@export var desertIslandAmount: int = 7
@export var enemyIslandAmount: int = 4

var gridSize = 30
var tileMapDict: Dictionary = {}
var selectedGlobalPosition: Vector2i
var selectedGridPosition: Vector2i



func _ready():
	for x in gridSize:
		for y in gridSize:
			set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0)
			tileMapDict[str(Vector2i(x, y))] = { 
				"type": "Ocean", 
				"gridPosition": Vector2i(x, y), 
				"globalPosition": getGlobalPosition(Vector2i(x, y)), 
				"isPlayerAt": false, 
				"reference": null, 
				"warningAmount": 0
			}
		#end for y
	#end for x
	generateDesertIslands()
	generateEnemyIslands()
#end func _ready

func _process(_delta):
	selectedGridPosition = getGridPosition(get_global_mouse_position() + Vector2(0, 8)) # Used "+ Vector2(0, 8)" because the map is isometric, so the selection area is different for the tilemap
	selectedGlobalPosition = getGlobalPosition(selectedGridPosition)
		
#	if (
#		!selectedGridPosition.x < 0 &&
#		!selectedGridPosition.x > gridSize-1 &&
#		!selectedGridPosition.y < 0 &&
#		!selectedGridPosition.y > gridSize-1
#	):
	for x in gridSize:
		for y in gridSize:
			erase_cell(1, Vector2i(x,y))
			if tileMapDict[ str(Vector2i(x,y)) ].warningAmount > 0:
				set_cell(3, Vector2i(x,y), 5, Vector2i(0, 0))
			else:
				erase_cell(3, Vector2i(x,y))

	if (
		gameManager.isPlayerTurn
	):
		if (player.getSelectablePosition()):
			set_cell(1, player.getSelectablePosition(), 1, Vector2i(0, 0))
		#end if
	#end if
#end func _process

func getRandomTile():
	return tileMapDict[ str(tileMapDict.keys()[ randi() % tileMapDict.size() ] ) ]
#end func getRandomTile

func getGridPosition(globalPosition: Vector2i):
	return local_to_map(globalPosition)
#end func getGridPosition

func getTile(gridPosition: Vector2i):
	return tileMapDict[ str(gridPosition) ]
#end func getTile

func getGlobalPosition(gridPosition: Vector2i):
	return map_to_local(gridPosition)
#end func getGlobalPosition

func isNear(tilesAmount: int, tileType: String, tile) -> bool:
	for x in range(tilesAmount):
		for y in range(tilesAmount):
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(x,y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(x,y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(-x,-y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(-x,-y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(x,-y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(x,-y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(-x,y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(-x,y)) ].type == tileType):
					return true
				#end if
			#end if
		#end for y
	#end for x

	return false
#end func isNear

func setAvailableCannonAtacks():
	var availableCannonAtackTiles: PackedVector2Array = player.getAvailableCannonAtackTiles()
	for availableTile in availableCannonAtackTiles:
		set_cell(2, availableTile, 4, Vector2i(0, 0))
	#end for
#end func setAvailableCannonAtacks

func cleanAtackTiles():
	for x in gridSize:
		for y in gridSize:
			erase_cell(2, Vector2i(x,y))
		#end for y
	#end for x
#end func cleanAtackTiles

func setWarningTiles(gridPosition: Vector2i, tileAmount):
	for x in tileAmount+1:
		for y in tileAmount+1:
			if tileMapDict.has( str(gridPosition + Vector2i(x, y)) ) && tileMapDict[str(gridPosition + Vector2i(x, y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(x, y)) ].warningAmount += 1
			#end if
			if tileMapDict.has( str(gridPosition + Vector2i(-x, y)) ) && tileMapDict[str(gridPosition + Vector2i(-x, y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(-x, y)) ].warningAmount += 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(x, -y)) ) && tileMapDict[str(gridPosition + Vector2i(x, -y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(x, -y)) ].warningAmount += 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(-x, -y)) ) && tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(-x, -y)) ].warningAmount += 1
			#end if
		#end for y
	#end for x
#end func setWarningTiles

func removeWarningTiles(gridPosition: Vector2i, tileAmount):
	for x in tileAmount+1:
		for y in tileAmount+1:
			if tileMapDict.has( str(gridPosition + Vector2i(x, y)) ) && tileMapDict[str(gridPosition + Vector2i(x, y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(x, y)) ].warningAmount -= 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(-x, y)) ) && tileMapDict[str(gridPosition + Vector2i(-x, y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(-x, y)) ].warningAmount -= 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(x, -y)) ) && tileMapDict[str(gridPosition + Vector2i(x, -y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(x, -y)) ].warningAmount -= 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(-x, -y)) ) && tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(-x, -y)) ].warningAmount -= 1
			#end if
		#end for y
	#end for x
#end func setWarningTiles

func generateDesertIslands() -> void:
	var desertIslandCount: int = 0
	var desertIslandCountIterations: int = 0
	var rangeToSpawn: int = 6 

	while true:
		desertIslandCountIterations += 1
		if desertIslandCount >= desertIslandAmount:
			break
		#end if

		#check if there is too many iterations and didnt find a position available
		if (desertIslandCountIterations >= 3 * desertIslandAmount):
			desertIslandCountIterations = 0
			rangeToSpawn -= 1
			if rangeToSpawn == 0:
				break
		#end if

		var desertIslandTile = getRandomTile()

		#check if random position is near another tile with this node
		if (desertIslandCount > 0 && isNear(rangeToSpawn, 'DesertIsland', desertIslandTile)):
			continue
		#end if

		if tileMapDict[str(desertIslandTile.gridPosition)].type == 'Ocean':
			desertIslandCount += 1
			tileMapDict[str(desertIslandTile.gridPosition)].type = 'DesertIsland'

			var desertIslandInstance = desertIsland.instantiate()
			desertIslandInstance.position = desertIslandTile.globalPosition

			get_node('/root/GameManager/Islands').add_child(desertIslandInstance)
		#end if
	#end while
#end func generateDesertIslands

func generateEnemyIslands() -> void:
	var enemyIslandCount: int = 0
	var enemyIslandCountIterations: int = 0
	var rangeToSpawn: int = 3 

	while true:
		if enemyIslandCount >= enemyIslandAmount:
			break
		#end if

		#check if there is too many iterations and didnt find a position available
		if (enemyIslandCountIterations >= 3 * enemyIslandAmount):
			enemyIslandCountIterations = 0
			rangeToSpawn -= 1
			if rangeToSpawn == 0:
				break
		#end if

		var enemyIslandTile = getRandomTile()

		#check if random position is near another tile with this node
		if (
			enemyIslandCount > 0 &&
			isNear(rangeToSpawn, 'EnemyIsland', enemyIslandTile)
		):
			continue
		#end if

		#instantiate node if found a good ocean tile
		if tileMapDict[str(enemyIslandTile.gridPosition)].type == 'Ocean':
			enemyIslandCount += 1

			var enemyIslandInstance: EnemyIsland = enemyIsland.instantiate()
			tileMapDict[str(enemyIslandTile.gridPosition)].type = 'EnemyIsland'
			tileMapDict[str(enemyIslandTile.gridPosition)].reference = enemyIslandInstance
			enemyIslandInstance.position = enemyIslandTile.globalPosition

			gameManager.islandEnemies.append(tileMapDict[str(enemyIslandTile.gridPosition)])
			setWarningTiles(enemyIslandTile.gridPosition, 2)
			get_node('/root/GameManager/Islands').add_child(enemyIslandInstance)
		#end if
	#end while
#end func generateEnemyIslands
