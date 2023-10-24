class_name GameManager
extends Node2D



########## SIGNALS ##########
signal startedPlayerTurn
signal finishedPlayerTurn
signal startedEnemyTurn
signal finishedEnemyTurn
signal enemyCanAct



########## VARS ##########
@onready var map: Map = get_node('./Map')
@onready var player: Player = get_node('./Player')
@onready var enemyIsland = get_node('./Islands/EnemyIsland')
#@onready var desertIsland = preload("res://Islands/DesertIsland.tscn")
#@onready var enemyIsland = preload("res://Islands/EnemyIsland.tscn")

@export var desertIslandAmount: int = 7
@export var enemyIslandAmount: int = 4

var isPlayerTurn = true
var maxActions = 15
var actions = maxActions
var islandEnemies: Dictionary = {}
var islandEnemiesFinishedTurnAmount = 0



########## FUNCS ##########
func _ready():
	startedPlayerTurn.emit()
	player.doAction.connect(controller, 1)
	player.attackWithCannon.connect(controller, 1)
	player.attackWithSniper.connect(controller, 1)
	for enemy in islandEnemies:
		islandEnemies[str(enemy)].reference.finishedTurn.connect(countFinishedEnemyTurn)
#	enemyIsland.finishedTurn.connect(countFinishedEnemyTurn)
#	finishedPlayerTurn.connect(controller)
#	finishedEnemyTurn.connect(controller)
#end func _ready

func handlePlayerDecision() -> void:
	print('-handlePlayerDecision')
#end func handlePlayerDecision

func handleIslandEnemies() -> void:
	print('handleIslandEnemies')
#end func handleIslandEnemies

func controller(actionAmountToDecrease: int) -> void:
	print()
	print('controller - isPlayerTurn: ', isPlayerTurn)
	print('beforeactions: ', actions)
	print('actionAmountToDecrease: ', actionAmountToDecrease)
	if isPlayerTurn:
#		handlePlayerDecision()

		actions -= actionAmountToDecrease
		if actions < 1:
			print('finishedPlayerTurn')
			isPlayerTurn = false
			actions = maxActions
			finishedPlayerTurn.emit()
			startedEnemyTurn.emit()
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
	print('afteractions: ', actions)
	#end while
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
	print('count')
	islandEnemiesFinishedTurnAmount += 1
	if islandEnemiesFinishedTurnAmount >= islandEnemies.size():
		print('ai')
		isPlayerTurn = true
		islandEnemiesFinishedTurnAmount = 0
		finishedEnemyTurn.emit()
		startedPlayerTurn.emit()
	#end if
#end func countFinishedEnemyTurn
