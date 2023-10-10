class_name Player
extends Node2D

@onready var tileMapDict = $"../Map".tileMapDict
@onready var playerSprite: Sprite2D = $"playerSprite"

var currentTile



func _ready():
	while true:
		currentTile = $"../Map".getRandomPosition()
		self.global_position = Vector2i($"../Map".getGlobalPosition(currentTile.position)) + Vector2i(1, -12)
		if currentTile.type == 'Ocean':
			tileMapDict[str(currentTile.position)].isPlayerAt = true
			break

	#print(tileMapDict[ str(tileMapDict.keys()[ randi() % tileMapDict.size() ] ) ] )


func _process(_delta):
	moveByMouseClick()


func moveByMouseClick() -> void:
	if Input.is_action_just_pressed('mouse_left') && $"../Map".canSelectPosition():
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
	if currentTile.position - newTile.position == Vector2i(0, -1):
		playerSprite.set_frame(0)
	elif currentTile.position - newTile.position == Vector2i(-1, 0):
		playerSprite.set_frame(1)
	elif currentTile.position - newTile.position == Vector2i(0, 1):
		playerSprite.set_frame(2)
	elif currentTile.position - newTile.position == Vector2i(1, 0):
		playerSprite.set_frame(3)
