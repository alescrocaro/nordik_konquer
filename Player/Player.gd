class_name Player
extends Node2D



########## SIGNALS ##########
signal died
signal doAction
signal scoreChanged
signal healthChanged
signal attackWithCannon
signal attackWithSniper
signal attackWithHarpoon



########## VARS ##########
@onready var playerSprite: Sprite2D = $"playerSprite"
@onready var map: Map = get_node('/root/GameManager/Map')
@onready var gameManager: GameManager = get_node('/root/GameManager')
@onready var myLOG: LOG = get_node('/root/GameManager/CanvasLayer/HudManager/LOG')
@onready var skipTurnButton: ButtonSkipTurn = get_node('/root/GameManager/CanvasLayer/HudManager/ButtonSkipTurn')
@onready var cannonAttackButton: CannonAttackButton = get_node('/root/GameManager/CanvasLayer/HudManager/FooterMarginContainer/CardsContainer/ButtonCannonAttack')
@onready var sniperAttackButton: SniperAttackButton = get_node('/root/GameManager/CanvasLayer/HudManager/FooterMarginContainer/CardsContainer/ButtonSniperAttack')
@onready var buttonTurnLeft: ButtonTurnLeft = get_node('/root/GameManager/CanvasLayer/HudManager/FooterMarginContainer/CardsContainer/TurnContainer/ButtonTurnLeft')
@onready var harpoonAttackButton: HarpoonAttackButton = get_node('/root/GameManager/CanvasLayer/HudManager/FooterMarginContainer/CardsContainer/ButtonHarpoonAttack')
@onready var buttonTurnRight: ButtonTurnRight = get_node('/root/GameManager/CanvasLayer/HudManager/FooterMarginContainer/CardsContainer/TurnContainer/ButtonTurnRight')
@onready var currentCannonBallsAmountLabel: CurrentCannonBallsAmount = get_node('/root/GameManager/CanvasLayer/HudManager/CannonBallsContainer/CurrentCannonBallsAmount')
@onready var currentSniperBulletsAmountLabel: CurrentSniperBulletsAmount = get_node('/root/GameManager/CanvasLayer/HudManager/SniperBulletsContainer/CurrentSniperBulletsAmount')

@onready var currentHealth: float = maxHealth
@onready var isAttackingWithCannon: bool = false
@onready var isAttackingWithSniper: bool = false
@onready var isAttackingWithHarpoon: bool = false

@export var playerCannonDamage: int = 20
@export var playerSniperDamage: int = 30
@export var playerHarpoonDamage: int = 10
@export var maxCannonBallsAmount: int = 30
@export var currentCannonBallsAmount: int = 30
@export var maxSniperBulletsAmount: int = 5
@export var currentSniperBulletsAmount: int = 5
@export var maxHealth: float = 100

var currentTile
var currentMovingDirection = 'N'
var combatMode = false
var sniperRangePositions = range(-3, 4, 1)
var harpoonRangePositions = range(1, 3, 1)
var spriteFrames = [0, 1, 2, 3]
var actionsToMove = 1
var actionsToMoveFromSwamp = 2
var actionsToAttackWithCannon = 2
var actionsToAttackWithSniper = 5
var actionsToAttackWithHarpoon = 2
var possibleWindDirections
var score = 0


######### FUNCS #########
func _ready():
	possibleWindDirections = gameManager.possibleWindDirections
	while true:
		currentTile = map.getRandomTile()
		if currentTile.type == 'Ocean':
			self.global_position = Vector2i(map.getGlobalPosition(currentTile.gridPosition)) + Vector2i(1, -12)
			map.tileMapDict[str(currentTile.gridPosition)].isPlayerAt = true
#			map.tileMapDict[str(currentTile.gridPosition)].type = 'Player'
			var directionFrame = randi() % 4
			playerSprite.set_frame(directionFrame)
			match directionFrame:
				0:
					currentMovingDirection = 'S'
				1:
					currentMovingDirection = 'L'
				2:
					currentMovingDirection = 'N'
				3:
					currentMovingDirection = 'O'
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
#			print('isAttackingWithHarpoon')
			handleHarpoonAttack()
		else:
			moveByMouseClick()
		#end 
	#end if
#end func _process

func moveByMouseClick() -> void:
	if (
		gameManager.isPlayerTurn &&
		Input.is_action_just_pressed('mouse_left') && 
		canSelectPositionToMove()
	):
		var actionsAmount = actionsToMoveFromSwamp if currentTile.type == 'Swamp' else actionsToMove
		
		if not isMovingInWindDirection():
			actionsAmount *= 2 
		
		var moveDict = {
			'moveType': 'MOVE_FROM_SWAMP' if currentTile.type == 'Swamp' else 'MOVE',
			'actions': actionsAmount,
		}
		if hasEnoughActionsLeft(moveDict.moveType, actionsAmount):
			if combatMode:
				if map.tileMapDict[ str(map.selectedGridPosition) ].warningAmount > 0: # if target position is warning tile, can move
					self.global_position = Vector2i(map.selectedGlobalPosition) + Vector2i(1, -12)
					currentTile = updatePosition(currentTile)
					doAction.emit(moveDict.actions)
				#end if
			#end if
			else:
				self.global_position = Vector2i(map.selectedGlobalPosition) + Vector2i(1, -12)
				currentTile = updatePosition(currentTile)
				doAction.emit(moveDict.actions)
			#end else
		#end if
		else:
			myLOG.addLOG('NOT ENOUGH ACTIONS')
		#end else
	#end if
#end func moveByMouseClick

func handleCannonAtack() -> void:
	if (
		gameManager.isPlayerTurn &&
		Input.is_action_just_pressed('mouse_left') &&
		canDoCannonAttack() &&
		isAttackingWithCannon
	):
		var enemyType = map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper()
		if (
			enemyType == 'SHIP' ||
	 		enemyType == 'ENEMYISLAND'
		):
			if map.tileMapDict[ str(map.selectedGridPosition) ].reference:
				if randi() % 100 <= 74: # has a 75% of chance of hitting target 
					myLOG.addLOG('SHOT ' + enemyType + ' WITH CANNON')
					map.tileMapDict[ str(map.selectedGridPosition) ].reference.tookHit(playerCannonDamage)
				else:
					myLOG.addLOG("MISS")
				updateCannonBallsAmount()
			else: # if clicking in anything that has not a reference, LOG shows the clicked tile type
				myLOG.addLOG("SHOT " + enemyType)
			#end if
			
			attackWithCannon.emit(actionsToAttackWithCannon)
		else:
			myLOG.addLOG("SHOT " + enemyType + ' WITH CANNON ')
		#end if
		enableButtons()
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
		var enemyType = map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper()
		if enemyType == 'SHIP':
			if map.tileMapDict[ str(map.selectedGridPosition) ].reference:
				if randi() % 100 <= 19: # has a 20% of chance of hitting target 
					myLOG.addLOG("SHOT " + enemyType + " WITH SNIPER")
					map.tileMapDict[ str(map.selectedGridPosition) ].reference.tookHit(playerSniperDamage)
				else:
					myLOG.addLOG("MISS")
				updateSniperBulletsAmount()
			else: # if clicking in anything that has not a reference, LOG shows the clicked tile type
				myLOG.addLOG("SHOT " + enemyType) 
			#end if
			attackWithSniper.emit(actionsToAttackWithSniper)
		else:
			myLOG.addLOG("CANNOT ATTACK " + enemyType + ' WITH SNIPER')
		#end if
		
		enableButtons()
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
		print('map.tileMapDict[ str(map.selectedGridPosition) ]', map.tileMapDict[ str(map.selectedGridPosition) ])
		if map.tileMapDict[ str(map.selectedGridPosition) ].isSharkAt:
			if map.tileMapDict[ str(map.selectedGridPosition) ].reference:
				if randi() % 100 <= 94: # has a 95% of chance of hitting target 
					map.tileMapDict[ str(map.selectedGridPosition) ].reference.tookHit(playerHarpoonDamage)
				else:
					myLOG.addLOG("MISS") # if miss the shot, it is shown on LOG
			else: # if clicking in anything that has not a reference, LOG shows the clicked tile type
				myLOG.addLOG("SHOT " + map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper())
			#end if

			attackWithHarpoon.emit(actionsToAttackWithHarpoon)
		else:
			myLOG.addLOG("CANNOT ATTACK " + map.tileMapDict[ str(map.selectedGridPosition) ].type.to_upper() + ' WITH HARPOON ')
		#end if

		enableButtons()
		isAttackingWithHarpoon = false
		map.cleanAttackTiles()
			
	#end if
#end func handleHarpoonAttack

func updatePosition(tile):
	map.tileMapDict[ str( tile.gridPosition ) ].isPlayerAt = false
	if map.tileMapDict[ str( tile.gridPosition ) ].type != 'Swamp':
		map.tileMapDict[ str( tile.gridPosition ) ].type = "Ocean"
	
	var selectedGridTile = map.tileMapDict[ str(map.selectedGridPosition) ]
	map.tileMapDict[ str( selectedGridTile.gridPosition ) ].isPlayerAt = true
#	map.tileMapDict[ str( selectedGridTile.gridPosition ) ].type = "Player"
	
	changeFrame(tile, selectedGridTile)
	currentTile = selectedGridTile
	
#	print(tile)

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
			(
				(map.tileMapDict[ str(currentTile.gridPosition - Vector2i(0,-1)) ].type == 'Ocean' ||
				map.tileMapDict[ str(currentTile.gridPosition - Vector2i(0,-1)) ].type == 'Swamp') && 
				!map.tileMapDict[ str(currentTile.gridPosition - Vector2i(0,-1)) ].isSharkAt
			) &&
			playerSprite.get_frame() == 0
		):
			return currentTile.gridPosition - Vector2i(0,-1)
		#end if
		if (
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(-1,0)) ) &&
			(
				(map.tileMapDict[ str(currentTile.gridPosition - Vector2i(-1,0)) ].type == 'Ocean' ||
				map.tileMapDict[ str(currentTile.gridPosition - Vector2i(-1,0)) ].type == 'Swamp') &&
				!map.tileMapDict[ str(currentTile.gridPosition - Vector2i(-1,0)) ].isSharkAt
			) &&
			playerSprite.get_frame() == 1
		):
			return currentTile.gridPosition - Vector2i(-1,0)
		#end if
		if(
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(0,1)) ) &&
			(
				(map.tileMapDict[ str(currentTile.gridPosition - Vector2i(0,1)) ].type == 'Ocean' ||
				map.tileMapDict[ str(currentTile.gridPosition - Vector2i(0,1)) ].type == 'Swamp') &&
				!map.tileMapDict[ str(currentTile.gridPosition - Vector2i(0,1)) ].isSharkAt
			) &&
			playerSprite.get_frame() == 2
		):
			return currentTile.gridPosition - Vector2i(0,1)
		#end if
		if( 
			map.tileMapDict.has( str(currentTile.gridPosition - Vector2i(1,0)) ) &&
			(
				(map.tileMapDict[ str(currentTile.gridPosition - Vector2i(1,0)) ].type == 'Ocean' ||
				map.tileMapDict[ str(currentTile.gridPosition - Vector2i(1,0)) ].type == 'Swamp') &&
				!map.tileMapDict[ str(currentTile.gridPosition - Vector2i(1,0)) ].isSharkAt
			) &&
			playerSprite.get_frame() == 3
		):
			return currentTile.gridPosition - Vector2i(1,0)
		#end if
	#end if
#end func getSelectablePositionToMove

func canSelectPositionToMove() -> bool:
	if (
		!isAttackingWithCannon && 
		!isAttackingWithSniper && 
		map.tileMapDict.has( str(map.selectedGridPosition) )
	):
		var tile = map.tileMapDict[ str(map.selectedGridPosition) ]
		if (
			(
				map.tileMapDict[ str(tile.gridPosition) ].type == 'Ocean' ||
				map.tileMapDict[ str(tile.gridPosition) ].type == 'Swamp'
			) && !map.tileMapDict[ str(tile.gridPosition) ].isSharkAt # MUDAR PARA HASOBSTACLE
		):
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

func hurtByEnemy(damageTaken: int) -> void:
	if (currentHealth - damageTaken) <= 0:
		currentHealth = 0
		died.emit()
	else: 
		updateScore(-1)
		currentHealth -= damageTaken
		healthChanged.emit()
		
#	print('currentHealth after damage: ', currentHealth)
#end func hurtByEnemy

func heal(amount) -> void:
	if (currentHealth + amount) >= maxHealth:
		currentHealth = maxHealth
	else: 
		currentHealth += amount
	
	healthChanged.emit()
#end func heal

func canDoCannonAttack() -> bool:
	var availableTilesToAttack = getAvailableCannonAttackTiles() 
	if (
		map.tileMapDict.has( str(map.selectedGridPosition) ) &&
		availableTilesToAttack.has( map.tileMapDict[str(map.selectedGridPosition)].gridPosition )
	):
		return true
	#end if

	return false
#end func canDoCannonAttack

func canDoSniperAttack() -> bool:
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

func canDoHarpoonAttack() -> bool:
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

func getAvailableCannonAttackTiles() -> PackedVector2Array: ##### TODO REFACTORING - use loop
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

func getAvailableSniperAttackTiles() -> PackedVector2Array:
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

func getAvailableHarpoonAttackTiles() -> PackedVector2Array: ##### TODO REFACTORING - use loop ?
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


#	print('availablePositions', availablePositions)
	return availablePositions
#end func getAvailableHarpoonAttackTiles

func handleRotate(direction: String) -> void:
	var currentFrame = playerSprite.get_frame()

	var frame: int = currentFrame - 1 if currentFrame > 0 else 3
	if direction == 'left':
		frame = currentFrame + 1 if currentFrame < 3 else 0
	#end if

	playerSprite.set_frame(frame)
	
	updateMovingDirection(direction)
	
	doAction.emit(actionsToMove)
#end func handleRotate

func enableButtons() -> void:
	cannonAttackButton.enableButton()
	sniperAttackButton.enableButton()
	harpoonAttackButton.enableButton()
	buttonTurnRight.enableButton()
	buttonTurnLeft.enableButton()
	skipTurnButton.enableButton()
#end func enableButtons

func updateSniperBulletsAmount() -> void:
	currentSniperBulletsAmount -= 1
	currentSniperBulletsAmountLabel.setText( str(currentSniperBulletsAmount) )
#end func updateSniperBulletsAmount

func updateCannonBallsAmount() -> void:
	currentCannonBallsAmount -= 1
	currentCannonBallsAmountLabel.setText( str(currentCannonBallsAmount) )
#end func updateCannonBallsAmount

func hasEnoughActionsLeft(type: String, moveActionsAmount: int = 0) -> bool:
	match type: # switch
		'CANNON':
			if actionsToAttackWithCannon > gameManager.actions:
				return false
			return true
		# end CANNON match
		'SNIPER':
			if actionsToAttackWithSniper > gameManager.actions:
				return false
			return true
		# end SNIPER match
		'HARPOON':
			if actionsToAttackWithHarpoon > gameManager.actions:
				return false
			return true
		# end HARPOON match
		'MOVE':
			if moveActionsAmount > gameManager.actions:
				return false
			return true
		# end MOVE match
		'MOVE_FROM_SWAMP':
			if moveActionsAmount > gameManager.actions:
				return false
			return true
		# end MOVE_FROM_SWAMP match
		_: # default
			return false 
		# end _ match
	# end match
#end func hasEnoughActionsLeft

func hasCannonBalls() -> bool:
	return currentCannonBallsAmount > 0
#end func hasCannonBalls

func hasSniperBullets() -> bool:
	return currentSniperBulletsAmount > 0
#end func hasCannonBalls

func isMovingInWindDirection() -> bool:
	if gameManager.windDirection == currentMovingDirection:
		return true

	return false
#end func isMovingInWindDirection

func updateMovingDirection(turnDirection):
	var currentMovingDirectionIndex = possibleWindDirections.find(currentMovingDirection)
	var amount: int = 0
	if turnDirection == 'left':
#		print('left')
		amount = -1
		if currentMovingDirectionIndex + amount < 0:
#			print('caso')
			amount = possibleWindDirections.size()-1
			currentMovingDirectionIndex = 0
	else:
#		print('right')
		amount = 1
		if currentMovingDirectionIndex + amount > possibleWindDirections.size()-1:
#			print('caso')
			amount = 0
			currentMovingDirectionIndex = 0

	currentMovingDirection = possibleWindDirections[currentMovingDirectionIndex + amount]
#end func updateMovingDirection

#	print('gameManager.possibleWindDirections', gameManager.possibleWindDirections)
#	print('currentMovingDirection', possibleWindDirections[currentMovingDirectionIndex + amount])
#	print('windDirection', gameManager.windDirection)
#end func handleChangeMovingDirection

func updateScore(scoreToAdd: int) -> void:
	score += scoreToAdd
	scoreChanged.emit()
#end func updateScore
