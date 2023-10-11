class_name Desert_island
extends Node2D

@onready var tileMapDict = $"../Map".tileMapDict
@onready var playerSprite: Sprite2D = $"playerSprite"

func _ready():
	while true:
		var currentTile = $"../Map".getRandomPosition()
		if currentTile.type == 'Ocean':
			self.global_position = Vector2i($"../Map".getGlobalPosition(currentTile.position)) + Vector2i(1, -12)
			tileMapDict[str(currentTile.position)].isPlayerAt = true
			playerSprite.set_frame(randi() % 4)
			break
