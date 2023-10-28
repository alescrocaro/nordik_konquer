class_name Swamp
extends Node2D



######### VARS #########
@onready var player: Player = get_node('/root/GameManager/Player')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var myLOG: LOG = get_node('/root/GameManager/CanvasLayer/HudManager/LOG')
@onready var self_node = $"."
@onready var currentGridPosition = map.getGridPosition(global_position)



######### FUNCS #########
func destroyYourself():
	map.tileMapDict[ str(currentGridPosition) ].type = 'Ocean'
	map.tileMapDict[ str(currentGridPosition) ].reference = null

	queue_free()
#end func destroyYourself
