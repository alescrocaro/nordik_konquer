class_name Map
extends TileMap

@onready var player: Player = get_node('/root/GameManager/Player')
@onready var gameManager: GameManager = get_node('/root/GameManager')

@export var desertIslandAmount: int = 7
@export var enemyIslandAmount: int = 4

var gridSize = 30
var tileMapDict: Dictionary = {}
var selectedGlobalPosition: Vector2i
var selectedGridPosition: Vector2i



func _ready():
	for x in gridSize:
		for y in gridSize:
			set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0)
			tileMapDict[str(Vector2i(x, y))] = { 
				"type": "Ocean", 
				"gridPosition": Vector2i(x, y), 
				"globalPosition": getGlobalPosition(Vector2i(x, y)), 
				"isPlayerAt": false, 
				"reference": null, 
				"warningAmount": 0
			}
		#end for y
	#end for x
#end func _ready

func _process(_delta):
	selectedGridPosition = getGridPosition(get_global_mouse_position() + Vector2(0, 8)) # Used "+ Vector2(0, 8)" because the map is isometric, so the selection area is different for the tilemap
	selectedGlobalPosition = getGlobalPosition(selectedGridPosition)
		
#	if (
#		!selectedGridPosition.x < 0 &&
#		!selectedGridPosition.x > gridSize-1 &&
#		!selectedGridPosition.y < 0 &&
#		!selectedGridPosition.y > gridSize-1
#	):
	for x in gridSize:
		for y in gridSize:
			erase_cell(1, Vector2i(x,y))
			if tileMapDict[ str(Vector2i(x,y)) ].warningAmount > 0:
				set_cell(3, Vector2i(x,y), 5, Vector2i(0, 0))
			else:
				erase_cell(3, Vector2i(x,y))

	if (
		gameManager.isPlayerTurn
	):
		if (player.getSelectablePosition()):
			set_cell(1, player.getSelectablePosition(), 1, Vector2i(0, 0))
		#end if
	#end if
#end func _process

func getRandomTile():
	return tileMapDict[ str(tileMapDict.keys()[ randi() % tileMapDict.size() ] ) ]
#end func getRandomTile

func getGridPosition(globalPosition: Vector2i):
	return local_to_map(globalPosition)
#end func getGridPosition

func getTile(gridPosition: Vector2i):
	return tileMapDict[ str(gridPosition) ]
#end func getTile

func getGlobalPosition(gridPosition: Vector2i):
	return map_to_local(gridPosition)
#end func getGlobalPosition

func isNear(tilesAmount: int, tileType: String, tile) -> bool:
	for x in range(tilesAmount):
		for y in range(tilesAmount):
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(x,y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(x,y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(-x,-y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(-x,-y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(x,-y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(x,-y)) ].type == tileType):
					return true
				#end if
			#end if
			if (tileMapDict.has( str(tile.gridPosition + Vector2i(-x,y)) ) ): 
				if (tileMapDict[ str(tile.gridPosition + Vector2i(-x,y)) ].type == tileType):
					return true
				#end if
			#end if
		#end for y
	#end for x

	return false
#end func isNear

func setAvailableCannonAtacks():
	var availableCannonAtackTiles: PackedVector2Array = player.getAvailableCannonAtackTiles()
	for availableTile in availableCannonAtackTiles:
		set_cell(2, availableTile, 4, Vector2i(0, 0))
#end func setAvailableCannonAtacks

func cleanAtackTiles():
	for x in gridSize:
		for y in gridSize:
			erase_cell(2, Vector2i(x,y))
		#end for y
	#end for x
#end func cleanAtackTiles

func setWarningTiles(gridPosition: Vector2i, tileAmount):
	for x in tileAmount+1:
		for y in tileAmount+1:
			if tileMapDict.has( str(gridPosition + Vector2i(x, y)) ) && tileMapDict[str(gridPosition + Vector2i(x, y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(x, y)) ].warningAmount += 1
			#end if
			if tileMapDict.has( str(gridPosition + Vector2i(-x, y)) ) && tileMapDict[str(gridPosition + Vector2i(-x, y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(-x, y)) ].warningAmount += 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(x, -y)) ) && tileMapDict[str(gridPosition + Vector2i(x, -y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(x, -y)) ].warningAmount += 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(-x, -y)) ) && tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(-x, -y)) ].warningAmount += 1
			#end if
		#end for y
	#end for x
#end func setWarningTiles

func removeWarningTiles(gridPosition: Vector2i, tileAmount):
	for x in tileAmount+1:
		for y in tileAmount+1:
			if tileMapDict.has( str(gridPosition + Vector2i(x, y)) ) && tileMapDict[str(gridPosition + Vector2i(x, y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(x, y)) ].warningAmount -= 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(-x, y)) ) && tileMapDict[str(gridPosition + Vector2i(-x, y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(-x, y)) ].warningAmount -= 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(x, -y)) ) && tileMapDict[str(gridPosition + Vector2i(x, -y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(x, -y)) ].warningAmount -= 1
			#end if

			if tileMapDict.has( str(gridPosition + Vector2i(-x, -y)) ) && tileMapDict[str(gridPosition + Vector2i(-x, -y)) ].type == 'Ocean':
				tileMapDict[ str(gridPosition + Vector2i(-x, -y)) ].warningAmount -= 1
			#end if
		#end for y
	#end for x
#end func setWarningTiles
