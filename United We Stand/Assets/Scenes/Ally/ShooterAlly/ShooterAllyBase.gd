extends AllyBase


# Declare member variables here. Examples:
var _aggroTargets = []
var stoppingToShoot
var inRange
var shotReady

export (PackedScene) var bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	shotReady = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_doShootingLogic()

func _moveToTarget(state):
	if (!stoppingToShoot and (aggroTarget != null)): 
		if !inRange:
			state.linear_velocity = state.linear_velocity.linear_interpolate(moveSpeed * position.direction_to(aggroTarget.position), .2)
		else:
		# look, man. I just wanna add a bit of variety in my life
		# this code makes half of the allies rotate clockwise and the other rotate counter clockwise
		# but also this code is so goddamn ugly please don't make fun of me
			if positionInLine % 2 == 0:
				state.linear_velocity = state.linear_velocity.linear_interpolate(moveSpeed * -position.direction_to(aggroTarget.position), .2).rotated(120)
			else:
				state.linear_velocity = state.linear_velocity.linear_interpolate(moveSpeed * -position.direction_to(aggroTarget.position), .2).rotated(-120)
	else:
		state.linear_velocity = Vector2.ZERO

func _chooseAggroTarget():
	aggroTarget = null
	var closestDistance = $"AggroZone/AggroZone Shape".shape.radius + 100
	for enemy in _aggroTargets:
		if position.distance_to(enemy.position) < closestDistance:
			aggroTarget = enemy
			closestDistance = global_position.distance_to(aggroTarget.global_position)

func _doShootingLogic():
	if aggroTarget != null and shotReady:
		shotReady = false
		$ShotCooldown.start()
		_stopToShoot()
		_fireShot(bullet, position.direction_to(aggroTarget.position))

func _stopToShoot():
	stoppingToShoot = true
	$MoveCooldown.start()

func _fireShot(bulletType, shotDirection):
	var theBullet = bulletType.instance()
	theBullet.position = $FirePoint.global_position
	theBullet.direction = shotDirection
	theBullet.look_at(shotDirection)
	get_parent().add_child(theBullet)


func _on_AggroZone_body_entered(body):
	if body.is_in_group("enemies"):
		_aggroTargets.push_back(body)


func _on_AggroZone_body_exited(body):
	if body.is_in_group("enemies"):
		_aggroTargets.erase(body)

func _on_ShotCooldown_timeout():
	shotReady = true

func _on_MoveCooldown_timeout():
	stoppingToShoot = false


func _on_InRangeZone_body_entered(body):
	if body == aggroTarget:
		inRange = true


func _on_InRangeZone_body_exited(body):
	if body == aggroTarget:
		inRange = false
