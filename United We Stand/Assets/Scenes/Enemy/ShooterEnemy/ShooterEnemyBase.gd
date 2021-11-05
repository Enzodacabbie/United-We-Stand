extends EnemyBase


# Declare member variables here.
var aggroTarget # holds reference to the current aggro target of the enemy
var shotReady # true when the enemy can fire another shot
export (PackedScene) var bullet # holds reference to the bullet this enemy fires


# Called when the node enters the scene tree for the first time.
func _ready():
	shotReady = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_doShootingLogic()

# this function handles shooting and can be overriden to implement more complex shot behavior
# this version fires a single shot at where the player was at time of shooting
func _doShootingLogic():
	if aggroTarget != null and shotReady:
		shotReady = false
		$ShotCooldown.start()
		_fireShot(bullet, $FirePoint.global_position.direction_to(aggroTarget.global_position))

# when called, this function shoots a single bullet from the fire point in
# the direction specified by vector2 shotDirection
func _fireShot(var bulletType, var shotDirection):
	var theBullet = bulletType.instance()
	theBullet.position = $FirePoint.global_position
	theBullet.direction = shotDirection
	theBullet.look_at(shotDirection)
	owner.add_child(theBullet)

func _on_AggroZone_body_entered(body):
	if(body.is_in_group("player")):
		aggroTarget = body

func _on_AggroZone_body_exited(body):
	if(body.is_in_group("player")):
		aggroTarget = null


func _on_ShotCooldown_timeout():
	shotReady = true
