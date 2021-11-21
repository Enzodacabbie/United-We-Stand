extends RigidBody2D
class_name AllyBase

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var playerFaceDirection = Vector2()
var aggroTarget

export var moveSpeed = 390

export var followDistance = 200
var positionInLine = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_getDirectionPlayerIsFacing()

func _integrate_forces(state):
	_movementHandler(state)

func _movementHandler(state: Physics2DDirectBodyState):
	if aggroTarget != null:
		_moveToTarget()
	else:
		_followPlayer(state)

func _moveToTarget():
	pass

func _followPlayer(state: Physics2DDirectBodyState):
	#if !$FollowZone.overlaps_body(player):
	if global_position.distance_to(player.global_position) >= followDistance:
		# linear_velocity = position.direction_to(player.global_position - (playerFaceDirection * followDistance))
		state.linear_velocity = global_position.direction_to(player.global_position) * moveSpeed
	elif state.linear_velocity.length() > 0:
		state.linear_velocity = state.linear_velocity.linear_interpolate(Vector2.ZERO, .2)

func _getDirectionPlayerIsFacing():
	playerFaceDirection = player.getFaceDirection()

func referencePlayer(thePlayer):
	player = thePlayer

func setPositionInLine(pos: int):
	positionInLine = pos
