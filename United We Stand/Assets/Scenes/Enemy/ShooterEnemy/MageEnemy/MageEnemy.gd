extends ShooterEnemyBase


# Declare member variables here.
export var bulletAngle = 15 # in degrees
export var numberOfBullets = 5 # per spreadshot

var bulletAngleRad # just a helpful in between to convert the degrees to radians

func _ready():
	bulletAngleRad = deg2rad(bulletAngle)

# the only modification is that instead of shooting one bullet, we call _fireSpreadshot
func _doShootingLogic():
	if aggroTarget != null and shotReady:
		shotReady = false
		$ShotCooldown.start()
		_fireSpreadshot()
		_stopToShoot()

# when called, this function fires numberOfBullets bullets, each bulletAngle degrees apart
# the center of the spread is towards the player
func _fireSpreadshot():
	# spreadSize is how wide (in radians) the entire spread of bullets is
	var spreadSize = bulletAngleRad * (numberOfBullets - 1)
	# currentAngle starts at half of spreadsize (negative) in order to center the spread
	var currentAngle = -spreadSize / 2
	# this gets used to rotate everything
	var directionToTarget = $FirePoint.global_position.direction_to(aggroTarget.global_position)
	while currentAngle <= spreadSize / 2:
		_fireShot(bullet, directionToTarget.rotated(currentAngle))
		currentAngle += bulletAngleRad
