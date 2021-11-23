extends KinematicBody2D

export var speed = 400 # the speed at which the player moves
var velocity = Vector2() # holds the direction the player is currently moving

var faceDirection = Vector2()

export (PackedScene) var bullet # reference to the bullet the player fires
export (int, 0, 200) var push = 100

var shotReady = true # true when the player can fire another shot

var _interactTargets = [] # array containing all interactable entities in range
var _interactTarget # reference to the closest interactTarget in range

var _allies = [] # array of all allies

export var maxHP = 15

var _numberOfAllies

signal scored_takedown

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawnAllies()
	_loadHP()
	_numberOfAllies = 0

func _loadHP():
	if PlayerData.maxHP == null:
		PlayerData.hp = maxHP
		PlayerData.maxHP = maxHP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tryDying()
	_shootingHandler()
	_chooseInteractTarget()
	_tryInteract()
	
	

func _animationHandler(): 
	if velocity == Vector2.ZERO:
		$AnimatedSprite.stop()
	else:
		$AnimatedSprite.play()
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			$AnimatedSprite.animation = "walk right"
		else:
			$AnimatedSprite.animation = "walk left"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "walk up"
	else:
		$AnimatedSprite.animation = "walk down"

func _physics_process(delta):
	_movementHandler()
	_animationHandler()
	_pushAllies()

func _movementHandler():
	velocity = Vector2()
	if Input.is_action_pressed("Up"):
		velocity.y -= 1
	if Input.is_action_pressed("Down"):
		velocity.y += 1
	if Input.is_action_pressed("Right"):
		velocity.x += 1
	if Input.is_action_pressed("Left"):
		velocity.x -= 1
	
	#the last direction the player was moving in is the direction they're facing
	if velocity != Vector2.ZERO:
		faceDirection = velocity.normalized()
	
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, .785398, false)

func _pushAllies():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("allies"):
			collision.collider.apply_central_impulse(-collision.normal * push)

func getFaceDirection():
	return faceDirection

# all code related to shooting handled in this function
func _shootingHandler():
	if Input.is_action_pressed("Shoot") and shotReady: # when the player is trying to shoot and cd is down
		shotReady = false # put bullet on cooldown
		$ShotCooldown.start()
		var newBullet = bullet.instance() # instance a bullet and place it at the fire point
		newBullet.transform = $FirePoint.get_global_transform()
		newBullet.connect("scored_takedown", self, "_onTakedown")
		owner.add_child(newBullet)


func _on_ShotCooldown_timeout():
	shotReady = true

func takeDamage(var amount):
	PlayerData.hp = clamp(PlayerData.hp - amount, 0, maxHP)

func _tryDying():
	if (PlayerData.hp == 0):
		print("heck")
		takeDamage(-100)
		get_tree().reload_current_scene()


func _on_InteractZone_body_entered(body):
	if(body.is_in_group("interactable")):
		_interactTargets.push_back(body)

func _on_InteractZone_body_exited(body):
	_interactTargets.erase(body)

func _spawnAllies():
	for index in PlayerData.allies:
		call_deferred("spawnAlly", PlayerData.allyScene[index], position, false)

func recruitAlly(type, spawnPosition: Vector2, sendToFront: bool):
	if sendToFront:
		PlayerData.allies.push_front(type)
	else:
		PlayerData.allies.push_back(type)
	spawnAlly(PlayerData.allyScene[type], spawnPosition, sendToFront)

func spawnAlly(type: PackedScene, spawnPosition: Vector2, sendToFront: bool):
	var newAlly: AllyBase = type.instance()
	newAlly.referencePlayer(self)
	newAlly.position = spawnPosition
	if sendToFront:
		_allies.push_front(newAlly)
	else:
		_allies.push_back(newAlly)
	_updateAllyPositions()
	get_parent().add_child(newAlly)

# called after a new ally is spawned in; automatically changes ally's positions
# in line behind the player
func _updateAllyPositions():
	for pos in range(_allies.size()):
		_allies[pos].setPositionInLine(pos + 1)
	_numberOfAllies = _allies.size()

func _chooseInteractTarget():
	_interactTarget = null
	var closestDistance = $"InteractZone/InteractZone Shape".shape.radius + 10
	for target in _interactTargets:
		target.call("toggleOff")
		if global_position.distance_to(target.global_position) < closestDistance:
			_interactTarget = target
			closestDistance = global_position.distance_to(target.global_position)
	if _interactTarget != null:
		_interactTarget.call("toggleOn")

func _tryInteract():
	if Input.is_action_just_pressed("Interact") and _interactTarget != null:
		_interactTarget.call("interact", self)

func _onTakedown():
	emit_signal("scored_takedown")
