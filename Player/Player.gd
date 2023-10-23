class_name Player
extends Node2D


########## SIGNALS ##########
signal healthChanged
signal startedAttack
signal finishedAttack
signal doAction

########## VARS ##########
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var playerSprite: Sprite2D = $"playerSprite"

@export var playerCannonDamage: float = 10 
@export var maxHealth: float = 100 
@onready var currentHealth: float = maxHealth
@onready var isAttackingWithCannon: bool = false

var currentTile
var combatMode = false



######### FUNCS #########
func _ready():
	while true:
		currentTile = map.getRandomTile()
		if currentTile.type == 'Ocean':
			self.global_position = Vector2i(map.getGlobalPosition(currentTile.gridPosition)) + Vector2i(1, -12)
			map.tileMapDict[str(currentTile.gridPosition)].isPlayerAt = true
			map.tileMapDict[str(currentTile.gridPosition)].type = 'Player'
			playerSprite.set_frame(randi() % 4)
			break
		#end if
	#end while

	#print(tileMapDict[ str(tileMapDict.keys()[ randi() % tileMapDict.size() ] ) ] )
#end func _ready

func _process(_delta):
	if gameManager.isPlayerTurn:
		if isAttackingWithCannon:
			handleCannonAtack()
		else:
			moveByMouseClick()
#end func _process


func moveByMouseClick() -> void:
	if (
		gameManager.isPlayerTurn &&
		Input.is_action_just_pressed('mouse_left') && 
		canSelectPosition()
	):
		if combatMode:
			if map.tileMapDict[ str(map.selectedGridPosition) ].warningAmount > 0:
				self.global_position = Vector2i(map.selectedGlobalPosition) + Vector2i(1, -12)
				currentTile = updatePosition(currentTile)
				doAction.emit()
		else:
			self.global_position = Vector2i(map.selectedGlobalPosition) + Vector2i(1, -12)
			currentTile = updatePosition(currentTile)
			doAction.emit()
		
	#end if
#end func moveByMouseClick


func handleCannonAtack() -> void:
	startingAttack()
	if (
		gameManager.isPlayerTurn &&
		Input.is_action_just_pressed('mouse_left') &&
		canDoCannonAttack() &&
		isAttackingWithCannon
	):
		if map.tileMapDict[ str(map.selectedGridPosition) ].reference:
			map.tileMapDict[ str(map.selectedGridPosition) ].reference.tookHit(playerCannonDamage)
		isAttackingWithCannon = false
		map.cleanAtackTiles()
		finishingAttack()
		
		doAction.emit()
	#end if
#end func handleCannonAtack


func updatePosition(tile):
	map.tileMapDict[ str( tile.gridPosition ) ].isPlayerAt = false
	map.tileMapDict[ str( tile.gridPosition ) ].type = "Ocean"
	
	var selectedGridTile = map.tileMapDict[ str(map.selectedGridPosition) ]
	map.tileMapDict[ str( selectedGridTile.gridPosition ) ].isPlayerAt = true
	map.tileMapDict[ str( selectedGridTile.gridPosition ) ].type = "Player"
	
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

func getSelectablePosition():
	if !isAttackingWithCannon:
		if (
			map.tileMapDict.has( str( currentTile.gridPosition - Vector2i(0,-1) ) ) &&
			map.tileMapDict[ str(currentTile.gridPosition - Vector2i(0,-1)) ].type == 'Ocean' &&
			playerSprite.get_frame() == 0
		):
			return currentTile.gridPosition - Vector2i(0,-1)
		#end if
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(-1,0)) ) &&
			map.tileMapDict[ str(currentTile.gridPosition - Vector2i(-1,0)) ].type == 'Ocean' &&
			playerSprite.get_frame() == 1
		):
			return currentTile.gridPosition - Vector2i(-1,0)
		#end if
		if(
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,1)) ) &&
			map.tileMapDict[ str(currentTile.gridPosition - Vector2i(0,1)) ].type == 'Ocean' &&
			playerSprite.get_frame() == 2
		):
			return currentTile.gridPosition - Vector2i(0,1)
		#end if
		if( 
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(1,0)) ) &&
			map.tileMapDict[ str(currentTile.gridPosition - Vector2i(1,0)) ].type == 'Ocean' &&
			playerSprite.get_frame() == 3
		):
			return currentTile.gridPosition - Vector2i(1,0)
		#end if
	#end if
#end func getSelectablePosition

func canSelectPosition():
	if !isAttackingWithCannon && map.tileMapDict.has( str(map.selectedGridPosition) ):
		var tile = map.tileMapDict[ str(map.selectedGridPosition) ]
		if (map.tileMapDict[ str(tile.gridPosition) ].type == 'Ocean'):
			if (
				map.tileMapDict.has( str(tile.gridPosition - Vector2i(0,1)) ) && (
					map.tileMapDict[ str(tile.gridPosition - Vector2i(0,1)) ].isPlayerAt &&
					playerSprite.get_frame() == 0
				) ||
				map.tileMapDict.has( str(tile.gridPosition - Vector2i(1,0)) ) && (
					map.tileMapDict[ str(tile.gridPosition - Vector2i(1,0)) ].isPlayerAt &&
					playerSprite.get_frame() == 1
				) ||
				map.tileMapDict.has( str(tile.gridPosition - Vector2i(0,-1)) ) && (
					map.tileMapDict[ str(tile.gridPosition - Vector2i(0,-1)) ].isPlayerAt &&
					playerSprite.get_frame() == 2
				) || 
				map.tileMapDict.has( str(tile.gridPosition - Vector2i(-1,0)) ) && (
					map.tileMapDict[ str(tile.gridPosition - Vector2i(-1,0)) ].isPlayerAt &&
					playerSprite.get_frame() == 3
				) 
			):
				return true
			#end if
		#end if
	#end if

	return false
#end func canSelectPosition

func hurtByEnemy(damageTaken):
	if (currentHealth - damageTaken) < 0:
		currentHealth = 0
	else: 
		currentHealth -= damageTaken
		
	print('currentHealth after damage: ', currentHealth)
	healthChanged.emit()
#end func hurtByEnemy

func heal(amount):
	if (currentHealth + amount) >= maxHealth:
		currentHealth = maxHealth
	else: 
		currentHealth += amount
	
	healthChanged.emit()

func canDoCannonAttack():
	if (
		(
			(
				playerSprite.get_frame() == 0 ||
				playerSprite.get_frame() == 2
			) && (
				map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(1,0)) ) ||
				map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(2,0)) ) ||
				map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(-1,0)) ) ||
				map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(-2,0)) )
			)
		) || (
			(
				playerSprite.get_frame() == 1 ||
				playerSprite.get_frame() == 3
			) &&
			(
				map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,1)) ) ||
				map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,2)) ) ||
				map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,-1)) ) ||
				map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,-2)) )
			)
		)
	):
		return true
	#end if

	return false
#end func canSelectPosition

func getAvailableCannonAtackTiles():
	var availablePositions: PackedVector2Array = []
	if (playerSprite.get_frame() == 0 || playerSprite.get_frame() == 2):
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(1,0)) )
		):
			availablePositions.append(currentTile.gridPosition - Vector2i(1,0))
			
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(2,0)) )
		):
			availablePositions.append(currentTile.gridPosition - Vector2i(2,0))
			
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(-1,0)) )
		):
			availablePositions.append(currentTile.gridPosition - Vector2i(-1,0))
			
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(-2,0)) ) 
		):
			availablePositions.append(currentTile.gridPosition - Vector2i(-2,0))
	#end if

	if (playerSprite.get_frame() == 1 || playerSprite.get_frame() == 3):
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,1)) )
		):
			availablePositions.append(currentTile.gridPosition - Vector2i(0,1))
			
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,2)) )
		):
			availablePositions.append(currentTile.gridPosition - Vector2i(0,2))
			
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,-1)) )
		):
			availablePositions.append(currentTile.gridPosition - Vector2i(0,-1))
			
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,-2)) )
		):
			availablePositions.append(currentTile.gridPosition - Vector2i(0,-2))
	#end if

	return availablePositions
#end func getAvailableCannonAtackTiles

func startingAttack():
	startedAttack.emit()
#end func startingAttack

func finishingAttack():
	finishedAttack.emit()
#end func finishingAttack

func handleRotate(direction: String):
	var currentFrame = playerSprite.get_frame()

	var frame: int = currentFrame - 1 if currentFrame > 0 else 3
	if direction == 'left':
		frame = currentFrame + 1 if currentFrame < 3 else 0
	#end if

	playerSprite.set_frame(frame)
	
	doAction.emit()
#end func handleRotate
