extends "res://Assets/Scenes/Enemy/ShooterEnemy/ShooterEnemyBase.gd"

# the Archer shoots 3 shots every time they go off cooldown.

# Declare member variables here. Examples:
export var shotsPerVolley = 3

var shotsLoaded
var isShooting

# Called when the node enters the scene tree for the first time.
func _ready():
	shotsLoaded = 0
	isShooting = false

func _doShootingLogic():
	if aggroTarget != null:
		if not isShooting and shotReady:
			shotsLoaded = shotsPerVolley
			isShooting = true
			shotReady = false
			$ShotCooldown.start()
			$RapidCooldown.start()
		elif shotsLoaded == 0:
			isShooting = false
			$RapidCooldown.stop()

func _on_RapidCooldown_timeout():
	_fireShot(bullet, $FirePoint.global_position.direction_to(aggroTarget.global_position))
	shotsLoaded = clamp(shotsLoaded -1, 0, shotsPerVolley)
