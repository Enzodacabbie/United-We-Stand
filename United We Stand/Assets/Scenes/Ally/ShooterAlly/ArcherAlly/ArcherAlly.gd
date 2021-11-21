extends "res://Assets/Scenes/Ally/ShooterAlly/ShooterAllyBase.gd"


# Declare member variables here. Examples:
export var shotsPerVolley = 3

var isShooting
var shotsLoaded


# Called when the node enters the scene tree for the first time.
func _ready():
	isShooting = false
	shotsLoaded = 0

func _doShootingLogic():
	if aggroTarget != null:
		if not isShooting and shotReady:
			shotsLoaded = shotsPerVolley
			isShooting = true
			shotReady = false
			$ShotCooldown.start()
			$RapidCooldown.start()
			_stopToShoot()
		elif shotsLoaded == 0:
			isShooting = false
			$RapidCooldown.stop()

func _on_RapidCooldown_timeout():
	if aggroTarget != null:
		_fireShot(bullet, $FirePoint.global_position.direction_to(aggroTarget.global_position))
	shotsLoaded = clamp(shotsLoaded -1, 0, shotsPerVolley)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
