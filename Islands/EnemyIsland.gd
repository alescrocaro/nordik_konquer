class_name EnemyIsland
extends Node2D

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@export var maxHealth: float = 30
@onready var currentHealth: float = maxHealth

# Called when the node enters the scene tree for the first time.
func _ready():
	currentHealth = maxHealth
#end func _ready

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	hurtPlayer()
	if currentHealth <= 0:
		destroyYourself()
#end func _process

func hurtPlayer():
	print('hurting player')
	player.hurtByEnemy(1)
#end func hurtPlayer

func destroyYourself():
	map.tileMapDict[ str(map.getGridPosition(global_position)) ].type = 'Ocean'
	queue_free()
#end func destroyYourself

func tookHit(damage: float):
	currentHealth -= damage
#end func tookHit
