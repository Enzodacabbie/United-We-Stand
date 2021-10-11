extends Area2D


# Declare member variables here. 
export var velocity = 700
var direction

var damage = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * velocity * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(damage)
		queue_free()
