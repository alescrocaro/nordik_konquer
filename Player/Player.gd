class_name Player
extends Node2D


######### VARS #########
@onready var Map = $"../Map"
@onready var playerSprite: Sprite2D = $"playerSprite"

var currentTile



######### FUNCS #########
func _ready():
	while true:
		currentTile = $"../Map".getRandomTile()
		if currentTile.type == 'Ocean':
			self.global_position = Vector2i($"../Map".getGlobalPosition(currentTile.gridPosition)) + Vector2i(1, -12)
			Map.tileMapDict[str(currentTile.gridPosition)].isPlayerAt = true
			playerSprite.set_frame(randi() % 4)
			break
		#end if
	#end while

	#print(tileMapDict[ str(tileMapDict.keys()[ randi() % tileMapDict.size() ] ) ] )
#end func _ready

func _process(_delta):
	moveByMouseClick()
#end func _process


func moveByMouseClick() -> void:
	if Input.is_action_just_pressed('mouse_left') && canSelectPosition():
		self.global_position = Vector2i(Map.selectedGlobalPosition) + Vector2i(1, -12)
		currentTile = updatePosition(currentTile)
	#end if
#end func moveByMouseClick


func updatePosition(tile):
	Map.tileMapDict[ str( tile.gridPosition ) ].isPlayerAt = false
	
	var selectedGridTile = Map.tileMapDict[ str(Map.selectedGridPosition) ]
	Map.tileMapDict[ str( selectedGridTile.gridPosition ) ].isPlayerAt = true
	
	changeFrame(tile, selectedGridTile)
	currentTile = selectedGridTile

	return selectedGridTile
#end func updatePosition


func changeFrame(tile, newTile) -> void:
	if tile.gridPosition - newTile.gridPosition == Vector2i(0, -1):
		playerSprite.set_frame(0)
	elif tile.gridPosition - newTile.gridPosition == Vector2i(-1, 0):
		playerSprite.set_frame(1)
	elif tile.gridPosition - newTile.gridPosition == Vector2i(0, 1):
		playerSprite.set_frame(2)
	elif tile.gridPosition - newTile.gridPosition == Vector2i(1, 0):
		playerSprite.set_frame(3)
	#end elifs
#end func changeFrame



func canSelectPosition():
	if Map.tileMapDict.has( str(Map.selectedGridPosition) ):
		var tile = Map.tileMapDict[ str(Map.selectedGridPosition) ]
		if (Map.tileMapDict[ str(tile.gridPosition) ].type == 'Ocean'):
			if (
				Map.tileMapDict.has( str(tile.gridPosition - Vector2i(0,1)) ) && (
					Map.tileMapDict[ str(tile.gridPosition - Vector2i(0,1)) ].isPlayerAt &&
					playerSprite.get_frame() == 0
				) ||
				Map.tileMapDict.has( str(tile.gridPosition - Vector2i(1,0)) ) && (
					Map.tileMapDict[ str(tile.gridPosition - Vector2i(1,0)) ].isPlayerAt &&
					playerSprite.get_frame() == 1
				) ||
				Map.tileMapDict.has( str(tile.gridPosition - Vector2i(0,-1)) ) && (
					Map.tileMapDict[ str(tile.gridPosition - Vector2i(0,-1)) ].isPlayerAt &&
					playerSprite.get_frame() == 2
				) || 
				Map.tileMapDict.has( str(tile.gridPosition - Vector2i(-1,0)) ) && (
					Map.tileMapDict[ str(tile.gridPosition - Vector2i(-1,0)) ].isPlayerAt &&
					playerSprite.get_frame() == 3
				) 
			):
				return true
			#end if
		#end if
	#end if

	return false
#end func canSelectPosition
