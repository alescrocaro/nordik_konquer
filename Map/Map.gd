class_name Map
extends TileMap

########## VARS ##########
@onready var player: Player = get_node('/root/GameManager/Player')
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var desertIsland = preload("res://Islands/DesertIsland.tscn")
@onready var enemyIsland = preload("res://Islands/EnemyIsland.tscn")

@export var desertIslandAmount: int = 7
@export var swampAmount: int = 9

var gridSize = 40
var tileMapDict: Dictionary = {}
var selectedGlobalPosition: Vector2i
var selectedGridPosition: Vector2i
var oceanLayer: int = 0
var selectionLayer: int = 1
var attackLayer: int = 2
var warningLayer: int = 3
var oceanSourceID: int = 0
var selectionSourceID: int = 1
var desertIslandSourceID: int = 2
var enemyIslandSourceID: int = 3
var attackSelectionSourceID: int = 4
var warningSourceID: int = 5
var swampSourceID: int = 6

var currentIslandEnemyAmount: int = 0
var initialMaxIslandEnemyAmount: int = 10



########## FUNCS ##########
func _ready():
	for x in gridSize:
		for y in gridSize:
			set_cell(oceanLayer, Vector2i(x, y), oceanSourceID, Vector2i(0, 0), 0)
			tileMapDict[str(Vector2i(x, y))] = { 
				"type": "Ocean", 
				"gridPosition": Vector2i(x, y), 
				"globalPosition": getGlobalPosition(Vector2i(x, y)), 
				"isPlayerAt": false, 
				"isSharkAt": false, 
				"reference": null, 
				"warningAmount": 0,
				"canAct": false,
				"hasObstacle": false
			}
		#end for y
	#end for x
	generateSwamp()
	generateDesertIslands()
	generateEnemyIslands(initialMaxIslandEnemyAmount)
#end func _ready

func _process(_delta):
	selectedGridPosition = getGridPosition(get_global_mouse_position() + Vector2(0, 8)) # Used "+ Vector2(0, 8)" because the map is isometric, so the selection area is different for the tilemap
	selectedGlobalPosition = getGlobalPosition(selectedGridPosition)
#	print('selected: ', selectedGridPosition)
#	if (currentIslandEnemyAmount < 2): generateEnemyIslands((randi() % 5) + 1)
		
#	if (
#		!selectedGridPosition.x < 0 &&
#		!selectedGridPosition.x > gridSize-1 &&
#		!selectedGridPosition.y < 0 &&
#		!selectedGridPosition.y > gridSize-1
#	):
	for x in gridSize:
		for y in gridSize:
			var tileType = tileMapDict[ str(Vector2i(x,y)) ].type
			erase_cell(1, Vector2i(x,y))
			if tileType == 'Swamp':
				set_cell(oceanLayer, Vector2i(x,y), swampSourceID, Vector2i(0, 0))
			else:
				set_cell(oceanLayer, Vector2i(x,y), oceanSourceID, Vector2i(0, 0))
#				erase_cell(1, Vector2i(x,y))
			
			#set warning tiles
			if tileMapDict[ str(Vector2i(x,y)) ].warningAmount > 0:
				set_cell(warningLayer, Vector2i(x,y), warningSourceID, Vector2i(0, 0))
			else: # if tile has no warningAmount, erase cell to turn it back into ocean
				erase_cell(3, Vector2i(x,y))
			#end if
		#end for y
	#end for x

	if (
		gameManager.isPlayerTurn
	):
		var targetPosition = player.getSelectablePositionToMove()
		if targetPosition:
#			print('testeeeee', tileMapDict[str(targetPosition)])
			if player.combatMode:
				if tileMapDict[ str(targetPosition) ].warningAmount > 0:
					set_cell(selectionLayer, targetPosition, selectionSourceID, Vector2i(0, 0))
			else:
#				print(targetPosition)
				set_cell(selectionLayer, targetPosition, selectionSourceID, Vector2i(0, 0))
			#end if
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
				if (tileMapDict[ str(tile.gridPosition + Vector2i(x,y)) ].isPlayerAt if tileType == 'Player' else tileMapDict[ str(tile.gridPosition + Vector2i(x,y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(-x,-y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(-x,-y)) ].isPlayerAt if tileType == 'Player' else tileMapDict[ str(tile.gridPosition + Vector2i(-x,-y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(x,-y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(x,-y)) ].isPlayerAt if tileType == 'Player' else tileMapDict[ str(tile.gridPosition + Vector2i(x,-y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(-x,y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(-x,y)) ].isPlayerAt if tileType == 'Player' else tileMapDict[ str(tile.gridPosition + Vector2i(-x,y)) ].type == tileType):
					return true
				#end if
			#end if
		#end for y
	#end for x

	return false
#end func isNear

#func setAvailableTilesToAttack(attackType):
#	var types = {
#		'CANNON': func(): player.getAvailableCannonAttackTiles(),
#		'SNIPER': func(): player.getAvailableSniperAttackTiles(),
#		'HARPOON': func(): player.getAvailableHarpoonAttackTiles(),
#	}
#	var availableAttackTiles: PackedVector2Array = types[attackType].call()
#	for availableTile in availableAttackTiles:
#		set_cell(attackLayer, availableTile, attackSelectionSourceID, Vector2i(0, 0))
#	#end for
##end func setAvailableTilesToAttack

func setAvailableCannonAttacks():##### TODO REFACTORING - MERGE setAvailableAttacks FUNCTIONS
	var availableAttackTiles: PackedVector2Array = player.getAvailableCannonAttackTiles()
	for availableTile in availableAttackTiles:
		set_cell(attackLayer, availableTile, attackSelectionSourceID, Vector2i(0, 0))
	#end for
#end func setAvailableCannonAttacks

func setAvailableSniperAttacks():##### TODO REFACTORING - MERGE setAvailableAttacks FUNCTIONS
	var availableAttackTiles: PackedVector2Array = player.getAvailableSniperAttackTiles()
	for availableTile in availableAttackTiles:
		set_cell(attackLayer, availableTile, attackSelectionSourceID, Vector2i(0, 0))
	#end for
#end func setAvailableSniperAttacks

func setAvailableHarpoonAttacks():##### TODO REFACTORING - MERGE setAvailableAttacks FUNCTIONS
	var availableAttackTiles: PackedVector2Array = player.getAvailableHarpoonAttackTiles()
	for availableTile in availableAttackTiles:
		set_cell(attackLayer, availableTile, attackSelectionSourceID, Vector2i(0, 0))
	#end for
#end func setAvailableHarpoonAttacks

func cleanAttackTiles():
	for x in gridSize:
		for y in gridSize:
			erase_cell(2, Vector2i(x,y))
		#end for y
	#end for x
#end func cleanAttackTiles

func setWarningTiles(gridPosition: Vector2i, tileAmount):
	for x in tileAmount+1:
		for y in tileAmount+1:
			if (
				tileMapDict.has( str(gridPosition + Vector2i(x, y)) ) && (
					tileMapDict[str(gridPosition + Vector2i(x, y)) ].type == 'Ocean' ||
					tileMapDict[str(gridPosition + Vector2i(x, y)) ].type == 'Swamp'
				)
			):
				tileMapDict[ str(gridPosition + Vector2i(x, y)) ].warningAmount += 1
			#end if
			if (
				tileMapDict.has( str(gridPosition + Vector2i(-x, y)) ) && (
					tileMapDict[str(gridPosition + Vector2i(-x, y)) ].type == 'Ocean' ||
					tileMapDict[str(gridPosition + Vector2i(-x, y)) ].type == 'Swamp'
				)
			):
				tileMapDict[ str(gridPosition + Vector2i(-x, y)) ].warningAmount += 1
			#end if

			if (
				tileMapDict.has( str(gridPosition + Vector2i(x, -y)) ) && (
					tileMapDict[str(gridPosition + Vector2i(x, -y)) ].type == 'Ocean' ||
					tileMapDict[str(gridPosition + Vector2i(x, -y)) ].type == 'Swamp'
				)
			):
				tileMapDict[ str(gridPosition + Vector2i(x, -y)) ].warningAmount += 1
			#end if

			if (
				tileMapDict.has( str(gridPosition + Vector2i(-x, -y)) ) && (
					tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].type == 'Ocean' ||
					tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].type == 'Swamp'
				)
			):
				tileMapDict[ str(gridPosition + Vector2i(-x, -y)) ].warningAmount += 1
			#end if
		#end for y
	#end for x
#end func setWarningTiles

func removeWarningTiles(gridPosition: Vector2i, tileAmount):
	for x in tileAmount+1:
		for y in tileAmount+1:
			if (
				tileMapDict.has( str(gridPosition + Vector2i(x, y)) ) && (
					tileMapDict[str(gridPosition + Vector2i(x, y)) ].type == 'Ocean' || 
					tileMapDict[str(gridPosition + Vector2i(x, y)) ].type == 'Swamp' || 
					tileMapDict[str(gridPosition + Vector2i(x, y)) ].isPlayerAt
				)
			):
				tileMapDict[ str(gridPosition + Vector2i(x, y)) ].warningAmount -= 1
			#end if

			if (
				tileMapDict.has( str(gridPosition + Vector2i(-x, y)) ) && (
					tileMapDict[str(gridPosition + Vector2i(-x, y)) ].type == 'Ocean' ||
					tileMapDict[str(gridPosition + Vector2i(-x, y)) ].type == 'Swamp' || 
					tileMapDict[str(gridPosition + Vector2i(-x, y)) ].isPlayerAt
				)
			):
				tileMapDict[ str(gridPosition + Vector2i(-x, y)) ].warningAmount -= 1
			#end if

			if (
				tileMapDict.has( str(gridPosition + Vector2i(x, -y)) ) && (
					tileMapDict[str(gridPosition + Vector2i(x, -y)) ].type == 'Ocean' ||
					tileMapDict[str(gridPosition + Vector2i(x, -y)) ].type == 'Swamp' || 
					tileMapDict[str(gridPosition + Vector2i(x, -y)) ].isPlayerAt
				)
			):
				tileMapDict[ str(gridPosition + Vector2i(x, -y)) ].warningAmount -= 1
			#end if

			if (
				tileMapDict.has( str(gridPosition + Vector2i(-x, -y)) ) && (
					tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].type == 'Ocean' ||
					tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].type == 'Swamp' || 
					tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].isPlayerAt
				)
			):
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

func generateEnemyIslands(enemyIslandAmount: int) -> void:
	var enemyIslandCount: int = 0
	var enemyIslandCountIterations: int = 0
	var rangeToSpawn: int = 3 

	while true:
		print('while')
		if enemyIslandCount >= enemyIslandAmount:
			print('break')
			print(tileMapDict)
			break
		#end if

		#check if there is too many iterations and didnt find a position available
		if (enemyIslandCountIterations >= 3 * enemyIslandAmount):
			enemyIslandCountIterations = 0
			rangeToSpawn -= 1
			if rangeToSpawn == 0:
				print('too many iters')
				break
			#end if
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
			print('generated')
			enemyIslandCount += 1

			var enemyIslandInstance: EnemyIsland = enemyIsland.instantiate()
			tileMapDict[str(enemyIslandTile.gridPosition)].type = 'EnemyIsland'
			tileMapDict[str(enemyIslandTile.gridPosition)].reference = enemyIslandInstance
			enemyIslandInstance.position = enemyIslandTile.globalPosition
			
#			updateIslandEnemyAmount(1)

			gameManager.islandEnemies[ str(enemyIslandTile.gridPosition) ] = tileMapDict[ str(enemyIslandTile.gridPosition) ]
			setWarningTiles(enemyIslandTile.gridPosition, 2)
			get_node('/root/GameManager/Islands').add_child(enemyIslandInstance)
		#end if
	#end while
#end func generateEnemyIslands

func generateSwamp() -> void:
	var swampCount: int = 0
	var swampCountIterations: int = 0
	var rangeToSpawn: int = 7

	while true:
		if swampCount >= swampAmount:
			break
		#end if

		#check if there is too many iterations and didnt find a position available
		if (swampCountIterations >= 3 * swampAmount):
			swampCountIterations = 0
			rangeToSpawn -= 1
			if rangeToSpawn == 0:
				break
		#end if

		var swampTile = getRandomTile()

		#check if random position is near another tile with this node
		if (
			swampCount > 0 &&
			isNear(rangeToSpawn, 'Swamp', swampTile)
		):
			continue
		#end if

		#instantiate node if found a good ocean tile
		if tileMapDict[str(swampTile.gridPosition)].type == 'Ocean':
			swampCount += 1
			generateSwampProcedurally(swampTile)
#			tileMapDict[str(swampTile.gridPosition)].type = 'Swamp'
#			set_cell(oceanLayer, swampTile.gridPosition, swampSourceID, Vector2i(0, 0))
		#end if
	#end while
#end func generateSwamps

func generateSwampProcedurally(swampTile):
	var swampSpread = 4
	var spreadedSwampTile = swampTile
	for i in range(0, swampSpread):
		tileMapDict[str(spreadedSwampTile.gridPosition)].type = 'Swamp'

		set_cell(oceanLayer, spreadedSwampTile.gridPosition, swampSourceID, Vector2i(0, 0))
		var maxIters = 6*swampSpread
		var currIter = 0
		while true:
			if currIter >= maxIters:
				break
			#end if
			var newRandomTile = getRandomTileNear(spreadedSwampTile, 2)
			print('newRandomTile', newRandomTile)
			if newRandomTile && newRandomTile.type == 'Ocean':
				spreadedSwampTile = newRandomTile
				break
			#end if
			currIter += 1
			#end while
#end func generateSwampProcedurally

func getRandomTileNear(tile, rangeToFind):
	var maxIters = 6*4
	var currIter = 0

	while true:
		if currIter >= maxIters:
			break
		var randomX = randi() % (rangeToFind+1)
		var randomY = randi() % (rangeToFind+1)
		var isXPositive = randi() % 2 == 1
		var isYPositive = randi() % 2 == 1
		if tileMapDict.has( str(Vector2i(tile.gridPosition.x+randomX if isXPositive else tile.gridPosition.x-randomX, tile.gridPosition.y+randomY if isYPositive else tile.gridPosition.y-randomY)) ):
			return tileMapDict[ str(Vector2i(tile.gridPosition.x+randomX if isXPositive else tile.gridPosition.x-randomX, tile.gridPosition.y+randomY if isYPositive else tile.gridPosition.y-randomY)) ]
		#end if
		
		currIter += 1
	#end while
	
	return null
#end func getRandomTileNear


func updateIslandEnemyAmount(valueToUpdate: int) -> void:
	currentIslandEnemyAmount += valueToUpdate
#end func updateEnemyAmount
