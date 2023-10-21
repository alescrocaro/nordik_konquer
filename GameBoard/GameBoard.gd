class_name GameManager
extends Node2D

########## VARS ##########
signal startedPlayerTurn
signal finishedPlayerTurn


########## VARS ##########
@onready var map: Map = get_node('./Map')
@onready var player: Player = get_node('./Player')
@onready var desertIsland = preload("res://Islands/DesertIsland.tscn")
@onready var enemyIsland = preload("res://Islands/EnemyIsland.tscn")

@export var desertIslandAmount: int = 7
@export var enemyIslandAmount: int = 4


var isPlayerTurn = true
var maxActions = 5
var actions = maxActions
var islandEnemies = []


########## FUNCS ##########
func _ready():
#	generateDesertIslands()
#	generateEnemyIslands()
	print(islandEnemies)
	
	player.doAction.connect(gameTurns)
#end func _ready

#func _process(_delta):
#	pass
#end func _process
#
#func generateDesertIslands() -> void:
#	var desertIslandCount: int = 0
#	var desertIslandCountIterations: int = 0
#	var rangeToSpawn: int = 6 
#
#	while true:
#		desertIslandCountIterations += 1
#		if desertIslandCount >= desertIslandAmount:
#			break
#		#end if
#
#		#check if there is too many iterations and didnt find a position available
#		if (desertIslandCountIterations >= 3 * desertIslandAmount):
#			desertIslandCountIterations = 0
#			rangeToSpawn -= 1
#			if rangeToSpawn == 0:
#				break
#		#end if
#
#		var desertIslandTile = map.getRandomTile()
#
#		#check if random position is near another tile with this node
#		if (desertIslandCount > 0 && map.isNear(rangeToSpawn, 'DesertIsland', desertIslandTile)):
#			continue
#		#end if
#
#		if map.tileMapDict[str(desertIslandTile.gridPosition)].type == 'Ocean':
#			desertIslandCount += 1
#			map.tileMapDict[str(desertIslandTile.gridPosition)].type = 'DesertIsland'
#
#			var desertIslandInstance = desertIsland.instantiate()
#			desertIslandInstance.position = desertIslandTile.globalPosition
#
#			get_node('./Islands').add_child(desertIslandInstance)
#		#end if
#	#end while
##end func generateDesertIslands
#
#func generateEnemyIslands() -> void:
#	var enemyIslandCount: int = 0
#	var enemyIslandCountIterations: int = 0
#	var rangeToSpawn: int = 3 
#
#	while true:
#		if enemyIslandCount >= enemyIslandAmount:
#			break
#		#end if
#
#		#check if there is too many iterations and didnt find a position available
#		if (enemyIslandCountIterations >= 3 * enemyIslandAmount):
#			enemyIslandCountIterations = 0
#			rangeToSpawn -= 1
#			if rangeToSpawn == 0:
#				break
#		#end if
#
#		var enemyIslandTile = map.getRandomTile()
#
#		#check if random position is near another tile with this node
#		if (
#			enemyIslandCount > 0 &&
#			map.isNear(rangeToSpawn, 'EnemyIsland', enemyIslandTile)
#		):
#			continue
#		#end if
#
#		#instantiate node if found a good ocean tile
#		if map.tileMapDict[str(enemyIslandTile.gridPosition)].type == 'Ocean':
#			enemyIslandCount += 1
#
#			var enemyIslandInstance: EnemyIsland = enemyIsland.instantiate()
#			map.tileMapDict[str(enemyIslandTile.gridPosition)].type = 'EnemyIsland'
#			map.tileMapDict[str(enemyIslandTile.gridPosition)].reference = enemyIslandInstance
#			enemyIslandInstance.position = enemyIslandTile.globalPosition
#
#			islandEnemies.append(map.tileMapDict[str(enemyIslandTile.gridPosition)])
#			map.setWarningTiles(enemyIslandTile.gridPosition, 2)
#			get_node('./Islands').add_child(enemyIslandInstance)
#		#end if
#	#end while
##end func generateEnemyIslands

func handlePlayerDecision() -> void:
	print('handlePlayerDecision')
#end func handlePlayerDecision

func handleIslandEnemies() -> void:
	print('handleIslandEnemies')
#end func handleIslandEnemies

func gameTurns() -> void:
	if isPlayerTurn:
		if actions == maxActions:
			startedPlayerTurn.emit()
		if actions <= 1:
			isPlayerTurn = false
			actions = 2
			finishedPlayerTurn.emit()
#			continue
		#end if
		
		handlePlayerDecision()
		
		actions -= 1
	#end if
	else:
		if actions <= 1:
			isPlayerTurn = true
			actions = 2
#			continue
		#end if
		
		handleIslandEnemies()
		
		actions -= 1
	#end else
	#end while
#end func gameTurns
