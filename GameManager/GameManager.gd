class_name GameManager
extends Node2D



########## SIGNALS ##########
signal startedPlayerTurn
signal finishedPlayerTurn
signal finishedEnemyTurn



########## VARS ##########
@onready var map: Map = get_node('./Map')
@onready var player: Player = get_node('./Player')
@onready var enemyIsland = get_node('./Islands/EnemyIsland')
@onready var windRoseSprite: WindRose =  get_node('./CanvasLayer/HudManager/WindRoseContainer/WindRoseSprite')
@onready var shark = preload("res://Shark/Shark.tscn")

@export var windDirection = 'N'
var possibleWindDirections = ['N', 'L', 'S', 'O']

var isPlayerTurn = true
var maxActions = 15
var actions = maxActions
var islandEnemies: Dictionary = {}
var islandEnemiesFinishedTurnAmount = 0
var countPlayerTurns = 0
var turnsToChangeWind = 1
var sharksAlive: int = -1
var chanceOfSpawnShark: float = 4
var sharkInstance: Shark = null

const sharkAmount: int = 1



########## FUNCS ##########
func _ready():
	var initialWindDirection = randi() % 4
#	print(initialWindDirection+1)
	windDirection = possibleWindDirections[initialWindDirection]
	windRoseSprite.changeFrame(windDirection)
	
	startedPlayerTurn.emit()
	player.died.connect(handleGameOver)
	player.doAction.connect(controller, 1)
	player.attackWithCannon.connect(controller, 1)
	player.attackWithSniper.connect(controller, 1)
	player.attackWithHarpoon.connect(controller, 1)
	for enemy in islandEnemies:
		islandEnemies[str(enemy)].reference.finishedTurn.connect(countFinishedEnemyTurn)
#	enemyIsland.finishedTurn.connect(countFinishedEnemyTurn)
#	finishedPlayerTurn.connect(controller)
#	finishedEnemyTurn.connect(controller)
#end func _ready

func _process(_delta):
	if (!islandEnemies.size()):
		get_tree().change_scene_to_file("res://uis/Win/win.tscn")
#end func _process

func controller(actionAmountToDecrease: int) -> void:
#	print()
#	print('controller - isPlayerTurn: ', isPlayerTurn)
#	print('beforeactions: ', actions)
#	print('actionAmountToDecrease: ', actionAmountToDecrease)
	if isPlayerTurn:
		actions -= actionAmountToDecrease
		if actions < 1:
			print('finishedPlayerTurn')
			countPlayerTurns += 1
			changeWindDirection()
			isPlayerTurn = false
			actions = maxActions
			finishedPlayerTurn.emit()
			return
		#end if
		else:
			if sharksAlive < 1: #% of chance of generate an shark
				if sharksAlive == 0: # sharksAlive -> gambiarra pra nao gerar o tubarao assim que ele morrer
					if randi() % 100 < 4:
						generateShark()
					#end if
				#end if
				else: # gambiarra pra nao gerar o tubarao assim que ele morrer
					sharksAlive += 1
				#end else
			#end if
			else:
				sharkInstance.selfController()
			#end else
		#end else
	#end if
#end func controller

func calculateDistance(point1: Vector2i, point2: Vector2i):
	var distanceX: int = point1.x - point2.x
	var distanceY: int = point1.y - point2.y
	
	if distanceX < 0:
		distanceX = -distanceX
	
	if distanceY < 0:
		distanceY = -distanceY
	
	return distanceX + distanceY - 1
#end func calculateDistance

func countFinishedEnemyTurn():
	#print('count')
	islandEnemiesFinishedTurnAmount += 1
	if islandEnemiesFinishedTurnAmount >= islandEnemies.size():
	#	print('ai')
		isPlayerTurn = true
		islandEnemiesFinishedTurnAmount = 0
		finishedEnemyTurn.emit()
		startedPlayerTurn.emit()
	#end if
#end func countFinishedEnemyTurn

func changeWindDirection():
	if countPlayerTurns % turnsToChangeWind == 0:
		var randomX = randi() % 2
		var randomY = randi() % 2
		var isXPositive = randi() % 2 == 1
		var isYPositive = randi() % 2 == 1
		
		# if the random vector is (0,0) does not change wind direction
		match Vector2i(randomX if isXPositive else -randomX, randomY if isYPositive else -randomY):
			Vector2i(1,0):
				windDirection = 'N'
			Vector2i(0,1):
				windDirection = 'L'
			Vector2i(-1,0):
				windDirection = 'S'
			Vector2i(0,-1):
				windDirection = 'O'

		windRoseSprite.changeFrame(windDirection)
#end func changeWindDirection

func generateShark():
	print("generateShark")
	var sharkCountIterations: int = 3
	var rangeToSpawn: int = 2

	while true:
		print('while true')
		#check if there is too many iterations and didnt find an available position
		if (sharkCountIterations >= 3 * sharkAmount):
			sharkCountIterations = 0
			rangeToSpawn -= 1
			if rangeToSpawn == 0:
				break
			#end if
		#end if
		sharkCountIterations += 1
		
		
		var possibleTiles = addPossibleSharkPositionsToArray()

		var sharkTile = possibleTiles[randi() % possibleTiles.size() ]

		if !sharkTile.isPlayerAt && (sharkTile.type == 'Ocean' || sharkTile.type == 'Swamp'):
			sharkInstance = shark.instantiate()
			map.tileMapDict[ str(sharkTile.gridPosition) ].isSharkAt = true
			map.tileMapDict[ str(sharkTile.gridPosition) ].reference = sharkInstance
			sharkInstance.position = sharkTile.globalPosition
			print('player tile: ', player.currentTile)
			
			sharksAlive = 1
			
			get_node('/root/GameManager/Enemies/Sharks').add_child(sharkInstance)
			break
		#end if
#end func generateShark

func addPossibleSharkPositionsToArray():
	var positions = []
	var tileMap = map.tileMapDict
	var playerTile = player.currentTile
	if tileMap.has( str(playerTile.gridPosition + Vector2i(1,0)) ) && tileMap[ str( playerTile.gridPosition + Vector2i(1,0) ) ].type == 'Ocean':
		positions.append( tileMap[ str(playerTile.gridPosition + Vector2i(1,0)) ] )
	#end if
	if tileMap.has( str(playerTile.gridPosition + Vector2i(-1,0)) ) && tileMap[ str( playerTile.gridPosition + Vector2i(-1,0) ) ].type == 'Ocean':
		positions.append( tileMap[ str(playerTile.gridPosition + Vector2i(-1,0)) ] )
	#end if
	if tileMap.has( str(playerTile.gridPosition + Vector2i(0,1)) ) && tileMap[ str( playerTile.gridPosition + Vector2i(0,1) ) ].type == 'Ocean':
		positions.append( tileMap[ str(playerTile.gridPosition + Vector2i(0,1)) ] )
	#end if
	if tileMap.has( str(playerTile.gridPosition + Vector2i(0,-1)) ) && tileMap[ str( playerTile.gridPosition + Vector2i(0,-1) ) ].type == 'Ocean':
		positions.append( tileMap[ str(playerTile.gridPosition + Vector2i(0,-1)) ] )
	#end if

	return positions
#end func addPossibleSharkPositionsToArray

func handleGameOver():
	get_tree().reload_current_scene()
	get_tree().change_scene_to_file('res://uis/GameOver/gameOver.tscn')
#end func handleGameOver


