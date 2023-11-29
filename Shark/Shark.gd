class_name Shark
extends Node2D



######### VARS #########
@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var myLOG: LOG = get_node('/root/GameManager/CanvasLayer/HudManager/LOG')
@onready var self_node = $"."
@onready var currentHealth: float = 777
@onready var currentGridPosition = map.getGridPosition(global_position)

@export var maxHealth: float = 1
@export var rangeAttack: int = 2
@export var damage: int = 5
@export var maxActionsAmount: int = 2
@export var actions: int = maxActionsAmount



######### FUNCS #########
func _ready():
	currentHealth = maxHealth
#	gameManager.finishedPlayerTurn.connect(selfController)
#end func _ready



func selfController():
	print('selfController')
	if actions < 1:
		actions = maxActionsAmount
		myLOG.addLOG("SHARK FINISHED TURN")
		print("SHARK FINISHED TURN")
		return
	#end if

	var diffX = player.currentTile.gridPosition.x - currentGridPosition.x
	var diffY = player.currentTile.gridPosition.y - currentGridPosition.y
	var diffSum = diffX + diffY
	if (diffX == 0 || diffY == 0) && (diffSum == 1 || diffSum == -1): # is in attackable position
		attackPlayer()
		myLOG.addLOG("SHARK ATTACKED")
		print("SHARK ATTACKED")
		actions = 0
	#end if
	else:
		updatePosition(diffX, diffY)
	#end else
	selfController()
#end func selfController


func _process(_delta):
#	hurtPlayer()'
	if currentHealth <= 0:
		destroyYourself()
	#end if
#end func _process

func attackPlayer():
#	print('attacking player')
	player.hurtByEnemy(damage)
#end func hurtPlayer

func destroyYourself():
	map.tileMapDict[ str(currentGridPosition) ].isSharkAt = false
	map.tileMapDict[ str(currentGridPosition) ].reference = null
	gameManager.sharksAlive = -3 # give player 3 rounds with no chance to spawn shark

	queue_free()
#end func destroyYourself

func tookHit(damageHit: float):
	currentHealth -= damageHit
#end func tookHit

func updatePosition(diffX, diffY):
	map.tileMapDict[ str( currentGridPosition ) ].isSharkAt = false
	var ref = map.tileMapDict[ str( currentGridPosition ) ].reference
	map.tileMapDict[ str( currentGridPosition ) ].reference = null
	var selectedTile = null
	if diffX != 0:
		if (
			map.tileMapDict.has( str( currentGridPosition + Vector2i(-1 if diffX < 0 else 1,0) ) ) &&
			(
				map.tileMapDict[ str( currentGridPosition + Vector2i(-1 if diffX < 0 else 1,0) ) ].type == 'Ocean' || # modify to use hasObstacle key
				map.tileMapDict[ str( currentGridPosition + Vector2i(-1 if diffX < 0 else 1,0) ) ].type == 'Swamp' # modify to use hasObstacle key
			)
		):
			selectedTile = map.tileMapDict[ str( currentGridPosition + Vector2i(-1 if diffX < 0 else 1,0) ) ]
			actions -= 1
		#end if
	#end if
	elif diffY != 0:
		if (
			map.tileMapDict.has( str( currentGridPosition + Vector2i(0,-1 if diffY < 0 else 1) ) ) &&
			(
				map.tileMapDict[ str( currentGridPosition + Vector2i(0,-1 if diffY < 0 else 1) ) ].type == 'Ocean' || # modify to use hasObstacle key
				map.tileMapDict[ str( currentGridPosition + Vector2i(0,-1 if diffY < 0 else 1) ) ].type == 'Swamp' # modify to use hasObstacle key
			)
		):
			selectedTile = map.tileMapDict[ str( currentGridPosition + Vector2i(0,-1 if diffY < 0 else 1) ) ]
			actions -= 1
		#end if
	#end if



#	changeFrame(tile, selectedGridTile)
	currentGridPosition = selectedTile.gridPosition
	global_position = map.getGlobalPosition(currentGridPosition)
	map.tileMapDict[ str( selectedTile.gridPosition ) ].isSharkAt = true
	map.tileMapDict[ str( currentGridPosition ) ].reference = ref
#end func checkIfIsPlayerNear



