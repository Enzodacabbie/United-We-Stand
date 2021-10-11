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

func _doShootingLogic():
	if aggroTarget != null and shotReady:
		shotReady = false
		$ShotCooldown.start()
		var theBullet = bullet.instance()
		theBullet.position = $FirePoint.global_position
		theBullet.direction = $FirePoint.global_position.direction_to(aggroTarget.global_position)
		theBullet.look_at(aggroTarget.position)
		owner.add_child(theBullet)

func _on_AggroZone_body_entered(body):
	if(body.is_in_group("player")):
		aggroTarget = body

func _on_AggroZone_body_exited(body):
	if(body.is_in_group("player")):
		aggroTarget = null



func _on_ShotCooldown_timeout():
	shotReady = true
