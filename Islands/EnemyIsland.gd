class_name EnemyIsland
extends Node2D



######### SIGNALS #########
signal healthChanged
signal doAction



######### VARS #########
@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var self_node = $"."
@onready var currentHealth: float = maxHealth

@export var maxHealth: float = 30
@export var rangeAttack: int = 2
@export var damage: int = 10




######### FUNCS #########
func _ready():
	currentHealth = maxHealth
	healthChanged.emit()
	
	gameManager.startedEnemyTurn.connect(checkIfThereIsPlayerNear)
#end func _ready

func _process(_delta):
#	hurtPlayer()
	if currentHealth <= 0:
		destroyYourself()
#end func _process

func hurtPlayer(damage):
	print('hurting player')
	player.hurtByEnemy(damage)
	doAction.emit()
#end func hurtPlayer

func destroyYourself():
	map.tileMapDict[ str(map.getGridPosition(global_position)) ].type = 'Ocean'
	map.removeWarningTiles(map.getGridPosition(global_position), rangeAttack)
	queue_free()
#end func destroyYourself

func tookHit(damage: float):
	currentHealth -= damage
	healthChanged.emit()
#end func tookHit

func checkIfThereIsPlayerNear():
	print('checkIfThereIsPlayerNear')
	var isPlayerNear = map.isNear(rangeAttack+1, 'Player', map.tileMapDict[ str(map.getGridPosition(global_position)) ])
	if isPlayerNear:
		hurtPlayer(damage)
#end func checkIfIsPlayerNear
