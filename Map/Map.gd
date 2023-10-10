extends TileMap

var gridSize = 30
var tileMapDict: Dictionary = {}
var selectedGlobalPosition: Vector2i
var selectedGridPosition: Vector2i
@onready var Player = $"../Player" 

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in gridSize:
		for y in gridSize:
			set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0)
			tileMapDict[str(Vector2i(x, y))] = { "type": "Ocean", "position": Vector2i(x, y), "isPlayerAt": false }
			
	print(Player.get_children())
	#print(tileMapDict)

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	
func getRandomPosition():
	return tileMapDict[ str(tileMapDict.keys()[ randi() % tileMapDict.size() ] ) ]
	
func getGridPosition(position: Vector2i):
	return local_to_map(position)
	
func getTile(position: Vector2i):
	return tileMapDict[ str(position) ]

func getGlobalPosition(position: Vector2i):
	return map_to_local(position)

