extends Area2D


# Declare member variables here.
export var velocity = 700
var direction # Vector2 containing the direction the bullet should fly 



# Called when the node enters the scene tree for the first time.
func _ready():
	# set the bullet's fly direction to where the mouse is at time of bullet instance
	direction = position.direction_to(get_global_mouse_position())
	$Sprite.rotate(atan(direction.y / direction.x))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# make the bullet fly constantly in one direction
	position += direction * velocity * delta
