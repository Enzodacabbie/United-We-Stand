extends EnemyBase

# Declare member variables here.
export var healAmount = 2

var _healTargets = [] # array containing which enemies will get healed
var _moveTargets = [] # array containing candidates for the healer to follow
var _followTarget # the enemy that this healer is currently trying to follow
export var moveSpeed = 125
export var followDistance = 125

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()

func _process(delta):
	# ._process(delta)
	pass

func _movementHandler(state: Physics2DDirectBodyState):
	state.linear_velocity = Vector2.ZERO
	if _followTarget != null:
		if global_position.distance_to(_followTarget.global_position) > followDistance:
			state.linear_velocity = moveSpeed * global_position.direction_to(_followTarget.global_position)

# when a body enters the healing radius...
func _on_HealZone_body_entered(body):
	# if it's an enemy,
	if(body.is_in_group("enemies")):
		# add it to the list of enemies to be healed
		_healTargets.push_back(body)


# when a body leaves the healing radius...
func _on_HealZone_body_exited(body):
	# take it off the heal list
	_healTargets.erase(body)

func castHeal():
	for friend in _healTargets:
		friend.takeDamage(-1 * healAmount)

func _chooseFollowTarget():
	# if there's no target, default to targeting null
	_followTarget = null
	# closestDistance's initialization value will always be larger than distance
	# to the furthest enemy on the follow list
	var closestDistance = $FollowZone/FollowZoneShape.shape.radius + 100
	for friend in _moveTargets:
		if friend != self and global_position.distance_to(friend.global_position) < closestDistance:
			_followTarget = friend
			closestDistance = global_position.distance_to(friend.global_position)

func _on_FollowZone_body_entered(body):
	# if it's an enemy,
	if(body.is_in_group("enemies")):
		# add it to the stalk
		_moveTargets.push_back(body)

func _on_FollowZone_body_exited(body):
	# take it off the stalk list
	_moveTargets.erase(body)

# ActTimer autostarts and is not oneshot. Every time the woman acts, she heals and then chooses a new target
func _on_ActTimer_timeout():
	if _moveTargets.size() > 1:
		castHeal()
		_chooseFollowTarget()
		$MoveCooldown.start()
