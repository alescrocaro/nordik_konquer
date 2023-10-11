class_name Player
extends Node2D

@onready var tileMapDict = $"../Map".tileMapDict
@onready var playerSprite: Sprite2D = $"playerSprite"

var currentTile



func _ready():
	while true:
		currentTile = $"../Map".getRandomTile()
		if currentTile.type == 'Ocean':
			self.global_position = Vector2i($"../Map".getGlobalPosition(currentTile.position)) + Vector2i(1, -12)
			tileMapDict[str(currentTile.position)].isPlayerAt = true
			playerSprite.set_frame(randi() % 4)
			break

	#print(tileMapDict[ str(tileMapDict.keys()[ randi() % tileMapDict.size() ] ) ] )


func _process(_delta):
	moveByMouseClick()


func moveByMouseClick() -> void:
	if Input.is_action_just_pressed('mouse_left') && canSelectPosition():
		self.global_position = Vector2i($"../Map".selectedGlobalPosition) + Vector2i(1, -12)
		currentTile = updatePosition(currentTile)


func updatePosition(currentTile):
	var selectedGridTile = $"../Map".getTile($"../Map".selectedGridPosition)
	tileMapDict[ str( currentTile.position ) ].isPlayerAt = false
	tileMapDict[ str( selectedGridTile.position ) ].isPlayerAt = true
	changeFrame(currentTile, selectedGridTile)
	print(currentTile.position, '->', selectedGridTile.position )
	currentTile = selectedGridTile
	return currentTile


func changeFrame(currentTile, newTile) -> void:
	print('changeFrame')
	if currentTile.position - newTile.position == Vector2i(0, -1):
		playerSprite.set_frame(0)
	elif currentTile.position - newTile.position == Vector2i(-1, 0):
		playerSprite.set_frame(1)
	elif currentTile.position - newTile.position == Vector2i(0, 1):
		playerSprite.set_frame(2)
	elif currentTile.position - newTile.position == Vector2i(1, 0):
		playerSprite.set_frame(3)



func canSelectPosition():
	if tileMapDict.has( str($"../Map".selectedGridPosition) ):
		var tile = $"../Map".getTile($"../Map".selectedGridPosition)
		if (
			tileMapDict.has( str(tile.position - Vector2i(-1,0)) ) && (
				tileMapDict[ str(tile.position - Vector2i(-1,0)) ].isPlayerAt &&
				playerSprite.get_frame() == 3
			) ||
			tileMapDict.has( str(tile.position - Vector2i(1,0)) ) && (
				tileMapDict[ str(tile.position - Vector2i(1,0)) ].isPlayerAt &&
				playerSprite.get_frame() == 1
			) ||
			tileMapDict.has( str(tile.position - Vector2i(0,-1)) ) && (
				tileMapDict[ str(tile.position - Vector2i(0,-1)) ].isPlayerAt &&
				playerSprite.get_frame() == 2
			) ||
			tileMapDict.has( str(tile.position - Vector2i(0,1)) ) && (
				tileMapDict[ str(tile.position - Vector2i(0,1)) ].isPlayerAt &&
				playerSprite.get_frame() == 0
			)
		):
			return true

	return false
