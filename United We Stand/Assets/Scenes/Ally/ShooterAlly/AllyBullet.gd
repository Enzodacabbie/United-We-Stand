extends Area2D


# Declare member variables here.
export var velocity = 700
var direction # Vector2 containing the direction the bullet should fly 

signal scored_takedown # emitted when this bullet deals a finishing blow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# make the bullet fly constantly in one direction
	position += direction * velocity * delta



func _on_Bullet_body_entered(body):
	if(body.is_in_group("enemies")):
		if body.takeDamage(1):
			emit_signal("scored_takedown")
		queue_free()
	else:
		queue_free()
