class_name EnemyIsland
extends Node2D

@onready var player: Player = get_node('/root/GameManager/Player')
@export var maxHealth: float = 30
@onready var currentHealth: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	currentHealth = maxHealth
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	await get_tree().create_timer(2).timeout 
	hurtPlayer()
	pass

func hurtPlayer():
	print('hurting player')
	player.hurtByEnemy(1)
