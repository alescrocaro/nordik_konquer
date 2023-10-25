class_name Player
extends Node2D



########## SIGNALS ##########
signal healthChanged
signal doAction
signal attackWithCannon
signal attackWithSniper
signal attackWithHarpoon



########## VARS ##########
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var playerSprite: Sprite2D = $"playerSprite"
@onready var log: Label = get_node('/root/GameManager/CanvasLayer/HudManager/LOG')

@export var playerCannonDamage: float = 20 
@export var playerSniperDamage: float = 30
@export var playerHarpoonDamage: float = 10
@export var maxHealth: float = 100 
@export var cannonBallMaxAmount: float = 10
@onready var currentHealth: float = maxHealth
@onready var isAttackingWithCannon: bool = false
@onready var isAttackingWithSniper: bool = false
@onready var isAttackingWithHarpoon: bool = false

var currentTile
var combatMode = false
var sniperRangePositions = range(-3, 4, 1)
var harpoonRangePositions = range(1, 3, 1)
var spriteFrames = [0, 1, 2, 3]
var actionsToMove = 1
var actionsToAttackWithCannon = 2
var actionsToAttackWithSniper = 4
var actionsToAttackWithHarpoon = 4



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
		elif isAttackingWithSniper:
			handleSniperAttack()
		elif isAttackingWithHarpoon:
			print('isAttackingWithHarpoon')
			handleHarpoonAttack()
		else:
			moveByMouseClick()
		#end ifelifelse
	#end if
#end func _process

func moveByMouseClick() -> void:
	if (
		gameManager.isPlayerTurn &&
		Input.is_action_just_pressed('mouse_left') && 
		canSelectPositionToMove()
	):
		if combatMode:
			if map.tileMapDict[ str(map.selectedGridPosition) ].warningAmount > 0:
				self.global_position = Vector2i(map.selectedGlobalPosition) + Vector2i(1, -12)
				currentTile = updatePosition(currentTile)
				doAction.emit(actionsToMove)
		else:
			self.global_position = Vector2i(map.selectedGlobalPosition) + Vector2i(1, -12)
			currentTile = updatePosition(currentTile)
			doAction.emit(actionsToMove)
		
	#end if
#end func moveByMouseClick

func handleCannonAtack() -> void:
	print('handleCannonAtack')
	if (
		gameManager.isPlayerTurn &&
		Input.is_action_just_pressed('mouse_left') &&
		canDoCannonAttack() &&
		isAttackingWithCannon
	):
		if (
			map.tileMapDict[ str(map.selectedGridPosition) ].type == 'Ship' ||
	 		map.tileMapDict[ str(map.selectedGridPosition) ].type == 'EnemyIsland'
		):
			if map.tileMapDict[ str(map.selectedGridPosition) ].reference:
				if randi() % 100 <= 89: # has a 90% of chance of hitting target 
					map.tileMapDict[ str(map.selectedGridPosition) ].reference.tookHit(playerCannonDamage)
				else:
					log.text = "MISS\n" + log.text # if miss the shot, it is shown on LOG
			else: # if clicking in anything that has not a reference, LOG shows the clicked tile type
				log.text = "SHOT ON " + map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper() + '\n' + log.text
			#end ifelse
			
			attackWithCannon.emit(actionsToAttackWithCannon)
		else:
			log.text = "CANNOT ATTACK " + map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper() + ' WITH CANNON ' + '\n' + log.text
		#end ifelse
		isAttackingWithCannon = false
		map.cleanAttackTiles()
	#end if
#end func handleCannonAtack

func handleSniperAttack() -> void:
	if (
		gameManager.isPlayerTurn &&
		Input.is_action_just_pressed('mouse_left') &&
		canDoSniperAttack() &&
		isAttackingWithSniper
	):
		if map.tileMapDict[ str(map.selectedGridPosition) ].type == 'Ship':
			if map.tileMapDict[ str(map.selectedGridPosition) ].reference:
				if randi() % 100 <= 19: # has a 20% of chance of hitting target 
					map.tileMapDict[ str(map.selectedGridPosition) ].reference.tookHit(playerSniperDamage)
				else:
					log.text = "MISS\n" + log.text # if miss the shot, it is shown on LOG
			else: # if clicking in anything that has not a reference, LOG shows the clicked tile type
				log.text = "SHOT ON " + map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper() + '\n' + log.text
			
			attackWithSniper.emit(actionsToAttackWithSniper)
		else:
			log.text = "CANNOT ATTACK " + map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper() + ' WITH SNIPER ' + '\n' + log.text
		#end ifelse
		isAttackingWithSniper = false
		map.cleanAttackTiles()
		#end if
#end func handleSniperAttack

func handleHarpoonAttack() -> void:
	if (
		Input.is_action_just_pressed('mouse_left') &&
		gameManager.isPlayerTurn &&
		canDoHarpoonAttack() &&
		isAttackingWithHarpoon
	):
		if map.tileMapDict[ str(map.selectedGridPosition) ].type == 'Shark':
			if map.tileMapDict[ str(map.selectedGridPosition) ].reference:
				if randi() % 100 <= 94: # has a 95% of chance of hitting target 
					map.tileMapDict[ str(map.selectedGridPosition) ].reference.tookHit(playerHarpoonDamage)
				else:
					log.text = "MISS\n" + log.text # if miss the shot, it is shown on LOG
			else: # if clicking in anything that has not a reference, LOG shows the clicked tile type
				log.text = "SHOT ON " + map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper() + '\n' + log.text
			
			attackWithSniper.emit(actionsToAttackWithSniper)
		else:
			log.text = "CANNOT ATTACK " + map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper() + ' WITH HARPOON ' + '\n' + log.text
		#end ifelse
		
		isAttackingWithHarpoon = false
		map.cleanAttackTiles()
			
	#end if
#end func handleHarpoonAttack

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

func getSelectablePositionToMove():
	if !isAttackingWithCannon && !isAttackingWithSniper && !isAttackingWithHarpoon: ##### TODO REFACTORING - only 1 var isAttacking
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
#end func getSelectablePositionToMove

func canSelectPositionToMove():
	if (
		!isAttackingWithCannon && 
		!isAttackingWithSniper && 
		map.tileMapDict.has( str(map.selectedGridPosition) )
	):
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
#end func canSelectPositionToMove

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
#end func heal

func canDoCannonAttack():
	var availableTilesToAttack = getAvailableCannonAttackTiles() 
	if (
		map.tileMapDict.has( str(map.selectedGridPosition) ) &&
		availableTilesToAttack.has( map.tileMapDict[str(map.selectedGridPosition)].gridPosition )
	):
		return true
	#end if

	return false
#end func canDoCannonAttack

func canDoSniperAttack():
	var availableTilesToAttack = getAvailableSniperAttackTiles() 
	if (
		map.tileMapDict.has( str(map.selectedGridPosition) ) &&
		availableTilesToAttack.has( map.tileMapDict[str(map.selectedGridPosition)].gridPosition )
	):
		return true
		#end for y
	#end for x

	return false
#end func canDoSniperAttack

func canDoHarpoonAttack():
	var availableTilesToAttack = getAvailableHarpoonAttackTiles() 
	if (
		map.tileMapDict.has( str(map.selectedGridPosition) ) &&
		availableTilesToAttack.has( map.tileMapDict[str(map.selectedGridPosition)].gridPosition )
	):
		return true
		#end for y
	#end for x

	return false
#end func canDoHarpoonAttack

func getAvailableCannonAttackTiles(): ##### TODO REFACTORING - use loop
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
#end func getAvailableCannonAttackTiles

func getAvailableSniperAttackTiles():
	var availablePositions: PackedVector2Array = []
	for x in sniperRangePositions:
		for y in sniperRangePositions:
			if (map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(x,y)) )):
				availablePositions.append(currentTile.gridPosition - Vector2i(x,y))
			#end if
		#end for y
	#end for x

	return availablePositions
#end func getAvailableSniperAttackTiles

func getAvailableHarpoonAttackTiles(): ##### TODO REFACTORING - use loop ?
	var availablePositions: PackedVector2Array = []

	if (
		map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,1)) )
	):
		availablePositions.append(currentTile.gridPosition - Vector2i(0,1))
	if (
		map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,-1)) )
	):
		availablePositions.append(currentTile.gridPosition - Vector2i(0,-1))
	if (
		map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(1,0)) )
	):
		availablePositions.append(currentTile.gridPosition - Vector2i(1,0))
	if (
		map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(-1,0)) )
	):
		availablePositions.append(currentTile.gridPosition - Vector2i(-1,0))


	print('availablePositions', availablePositions)
	return availablePositions
#end func getAvailableHarpoonAttackTiles

func handleRotate(direction: String):
	var currentFrame = playerSprite.get_frame()

	var frame: int = currentFrame - 1 if currentFrame > 0 else 3
	if direction == 'left':
		frame = currentFrame + 1 if currentFrame < 3 else 0
	#end if

	playerSprite.set_frame(frame)
	
	doAction.emit(actionsToMove)
#end func handleRotate
