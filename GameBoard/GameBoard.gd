class_name GameManager
extends Node2D



########## SIGNALS ##########
signal startedPlayerTurn
signal finishedPlayerTurn
signal startedEnemyTurn
signal finishedEnemyTurn



########## VARS ##########
@onready var map: Map = get_node('./Map')
@onready var player: Player = get_node('./Player')
@onready var enemyIsland = get_node('./Islands/EnemyIsland')
#@onready var desertIsland = preload("res://Islands/DesertIsland.tscn")
#@onready var enemyIsland = preload("res://Islands/EnemyIsland.tscn")

@export var desertIslandAmount: int = 7
@export var enemyIslandAmount: int = 4

var isPlayerTurn = true
var maxActions = 25
var actions = maxActions
var islandEnemies = []



########## FUNCS ##########
func _ready():
	player.doAction.connect(controller)
	enemyIsland.doAction.connect(controller)
	finishedPlayerTurn.connect(controller)
	finishedEnemyTurn.connect(controller)
#end func _ready

func handlePlayerDecision() -> void:
	print('-handlePlayerDecision')
#end func handlePlayerDecision

func handleIslandEnemies() -> void:
	print('handleIslandEnemies')
#end func handleIslandEnemies

func controller() -> void:
	print()
	print('controller, isPlayerTurn: ', isPlayerTurn)
	print('beforeactions: ', actions)
	if isPlayerTurn:
		if actions == maxActions:
			print('actions == maxActions')
			startedPlayerTurn.emit()
		#end if
		actions -= 1
		if actions < 1:
			print('finishedPlayerTurn')
			isPlayerTurn = false
			actions = maxActions
			finishedPlayerTurn.emit()
		#end if

		handlePlayerDecision()

	#end if
	else:
		if actions == maxActions:
			print('actions == maxActions')
			startedEnemyTurn.emit()
		#end if
		actions -= 1
		if actions < 1:
			print('finishedEnemyTurn')
			isPlayerTurn = true
			actions = maxActions
			finishedEnemyTurn.emit()
		#end if

		handleIslandEnemies()
	#end else
	print('afteractions: ', actions)
	#end while
#end func controller
