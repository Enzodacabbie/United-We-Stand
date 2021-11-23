extends Area2D


# Declare member variables here. 
export var velocity = 400
var targetPosition

var damage = 2

export (PackedScene) var smallBullet

export (AudioStream) var shootSound
export (AudioStream) var boomSound

func _ready():
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.set_stream(shootSound)
	audioPlayer.set_volume_db(-8)
	get_parent().add_child(audioPlayer)
	audioPlayer.play()

func _physics_process(delta):
	if position != targetPosition:
		position = position.move_toward(targetPosition, velocity * delta)
	else:
		explode(12)

func explode(numberOfShots):
	for n in numberOfShots:
		var newBullet = smallBullet.instance()
		var rotationAngle = PI * 2 / numberOfShots * n
		newBullet.position = position
		newBullet.direction = Vector2.RIGHT.rotated(rotationAngle)
		get_parent().add_child(newBullet)
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.set_stream(boomSound)
	audioPlayer.set_volume_db(-8)
	get_parent().add_child(audioPlayer)
	audioPlayer.play()
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(damage)
		queue_free()
	else:
		queue_free()
