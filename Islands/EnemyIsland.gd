class_name EnemyIsland
extends Node2D



######### SIGNALS #########
signal healthChanged
signal finishedTurn



######### VARS #########
@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var myLOG: LOG = get_node('/root/GameManager/CanvasLayer/HudManager/LOG')
@onready var self_node = $"."
@onready var currentHealth: float = maxHealth
@onready var currentGridPosition = map.getGridPosition(global_position)

@export var maxHealth: float = 30
@export var rangeAttack: int = 2
@export var damage: int = 4
@export var maxActionsAmount: int = 3
@export var actions: int = maxActionsAmount



######### FUNCS #########
func _ready():
	currentHealth = maxHealth
	healthChanged.emit()
	
	gameManager.finishedPlayerTurn.connect(selfController)
#end func _ready



func selfController():
	if actions < 1:
		finishedTurn.emit()
		actions = maxActionsAmount
		print('selfController- finished turn')
		return
	if isPlayerNear():
		print('selfController- isPlayerNear')
		attackPlayer()
		myLOG.addLOG("ISLAND ENEMY ATTACKED")
		actions -= 1
		selfController()
	else:
		print('cant hurt player')
		myLOG.addLOG("ISLAND ENEMY FINISH TURN")
		actions = maxActionsAmount
		finishedTurn.emit()

	#end if
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
	gameManager.islandEnemies.erase(str(currentGridPosition))

	map.tileMapDict[ str(currentGridPosition) ].type = 'Ocean'
	map.tileMapDict[ str(currentGridPosition) ].reference = null
	map.removeWarningTiles(currentGridPosition, rangeAttack)

#	map.updateIslandEnemyAmount(-1)
	player.updateScore(5)

	queue_free()
#end func destroyYourself

func tookHit(damageHit: float):
	currentHealth -= damageHit
	healthChanged.emit()
#end func tookHit

func isPlayerNear():
#	print('isPlayerNear: ', map.isNear(rangeAttack+1, 'Player', map.tileMapDict[ str(map.getGridPosition(global_position)) ]))
	return map.isNear(rangeAttack+1, 'Player', map.tileMapDict[ str(map.getGridPosition(global_position)) ])
#end func checkIfIsPlayerNear

