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
#@onready var desertIsland = preload("res://Islands/DesertIsland.tscn")
#@onready var enemyIsland = preload("res://Islands/EnemyIslahnd.tscn")

@export var desertIslandAmount: int = 7
@export var enemyIslandAmount: int = 4
@export var windDirection = 'N'
var possibleWindDirections = ['N', 'L', 'S', 'O']

var isPlayerTurn = true
var maxActions = 15
var actions = maxActions
var islandEnemies: Dictionary = {}
var islandEnemiesFinishedTurnAmount = 0
var countPlayerTurns = 0
var turnsToChangeWind = 1



########## FUNCS ##########
func _ready():
	var initialWindDirection = randi() % 4
	print(initialWindDirection+1)
	windDirection = possibleWindDirections[initialWindDirection]
	windRoseSprite.changeFrame(windDirection)
	
	startedPlayerTurn.emit()
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

func controller(actionAmountToDecrease: int) -> void:
#	print()
#	print('controller - isPlayerTurn: ', isPlayerTurn)
#	print('beforeactions: ', actions)
#	print('actionAmountToDecrease: ', actionAmountToDecrease)
	if isPlayerTurn:
#		handlePlayerDecision()

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
	#end if
	
#	else:
#		print('------ ENTROU ELSE ------')
##		handleIslandEnemies()
##		actions -= 1
##		if actions < 1:
##			print('finishedEnemyTurn')
##			isPlayerTurn = true
##			actions = maxActions
##			#finishedEnemyTurn.emit()
##			startedPlayerTurn.emit()
##			return
##		#end if
##		while (actions >= 1):
#		print(islandEnemies.values())
#
#		var i = islandEnemies.size()
#		for islandEnemy in islandEnemies:
#			print(islandEnemy)
#			var hasAttacked: bool = islandEnemies[ str(islandEnemy) ].reference.attackPlayer()
#			if hasAttacked:
#				actions -= 1
#				islandEnemies[ str(islandEnemy) ].canAct = true
#				if actions < 1:
#					break
#			else:
#				islandEnemies[ str(islandEnemy) ].canAct = false
#			#end ifelse
#		#end for
##		startedPlayerTurn.emit()
#		#end while
#	#end else
	#end while
	#print('afteractions: ', actions)
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
