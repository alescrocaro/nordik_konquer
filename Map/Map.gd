extends TileMap

@onready var Player = $"../Player" 

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
			tileMapDict[str(Vector2i(x, y))] = { "type": "Ocean", "position": Vector2i(x, y), "isPlayerAt": false }
	
	generateDesertIslands()
	
	generateEnemyIslands()

func _process(delta):
	selectedGridPosition = getGridPosition(get_global_mouse_position() + Vector2(0, 8)) # Used "+ Vector2(0, 8)" because the map is isometric, so the selection area is different for the tilemap
	selectedGlobalPosition = getGlobalPosition(selectedGridPosition)
		
	if (
		!selectedGridPosition.x < 0 &&
		!selectedGridPosition.x > gridSize-1 &&
		!selectedGridPosition.y < 0 &&
		!selectedGridPosition.y > gridSize-1
	):
		#print(selectedGridPosition)
		for x in gridSize:
			for y in gridSize:
				erase_cell(1, Vector2i(x,y))
		
		if Player.canSelectPosition():
			print('true')
			set_cell(1, selectedGridPosition, 1, Vector2i(0, 0), 0)


func getRandomTile():
	return tileMapDict[ str(tileMapDict.keys()[ randi() % tileMapDict.size() ] ) ]
	
func getGridPosition(position: Vector2i):
	return local_to_map(position)
	
func getTile(position: Vector2i):
	return tileMapDict[ str(position) ]

func getGlobalPosition(position: Vector2i):
	return map_to_local(position)

func isNear(tilesAmount: int, tileType: String, tile) -> bool:
	for x in range(tilesAmount):
		for y in range(tilesAmount):
			if (
				tileMapDict.has( str(tile.position - Vector2i(x,y)) ) && (
					tileMapDict[ str(tile.position - Vector2i(x,y)) ].type == tileType
				)
			):
				return true
			#end if
		#end for y
	#end for x
	return false

func generateDesertIslands() -> void:
	var desertIslandCount: int = 0
	var desertIslandCountIterations: int = 0

	while true:
		if desertIslandCount >= desertIslandAmount:
			break

		var desertIslandTile = getRandomTile()

		if (isNear(5, 'DesertIsland', desertIslandTile) && desertIslandCountIterations < 3 * desertIslandAmount):
			return

		if desertIslandTile.type == 'Ocean':
			desertIslandCount += 1
			set_cell(2, desertIslandTile.position, 2, Vector2i(0, 0), 0)
			desertIslandTile.type = "DesertIsland"

func generateEnemyIslands() -> void:
	var enemyIslandCount: int = 0
	var enemyIslandCountIterations: int = 0

	while true:
		if enemyIslandCount >= enemyIslandAmount:
			break

		var enemyIslandTile = getRandomTile()

		if (isNear(6, 'EnemyIsland', enemyIslandTile) && enemyIslandCountIterations < 3 * enemyIslandAmount):
			return

		if enemyIslandTile.type == 'Ocean':
			enemyIslandCount += 1
			set_cell(2, enemyIslandTile.position, 3, Vector2i(0, 0), 0)
			enemyIslandTile.type = "EnemyIsland"

