extends Area2D


# Declare member variables here. Examples:
export var velocity = 600
export var waveSpeed = 11
export var waveLength = 2
var initialDirection = Vector2()
var currentDirection = Vector2()

var damage = 1

var timeAlive = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# for testing
	if initialDirection == Vector2.ZERO:
		initialDirection = Vector2(1,.5).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timeAlive += waveLength * delta
	currentDirection = initialDirection.rotated(sin(timeAlive * waveSpeed))
	position += currentDirection * velocity * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(damage)
		queue_free()
	else:
		queue_free()
