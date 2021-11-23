extends Area2D


# Declare member variables here. 
export var velocity = 500
var direction

var damage = 1
export (AudioStream) var shootSound
func _ready():
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.set_stream(shootSound)
	audioPlayer.set_volume_db(-8)
	get_parent().add_child(audioPlayer)
	audioPlayer.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * velocity * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(damage)
		queue_free()
	else:
		queue_free()
