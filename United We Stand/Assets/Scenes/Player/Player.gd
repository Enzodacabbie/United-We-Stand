extends KinematicBody2D

export var speed = 250 # the speed at which the player moves
var velocity = Vector2() # holds the direction the player is currently moving

export (PackedScene) var bullet # reference to the bullet the player fires

var shotReady = true # true when the player can fire another shot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_get_input()
	move_and_collide(velocity*delta)
	
	_shootingHandler()
	

func _get_input():
	velocity = Vector2()
	if Input.is_action_pressed("Up"):
		velocity.y -= 1
	if Input.is_action_pressed("Down"):
		velocity.y += 1
	if Input.is_action_pressed("Right"):
		velocity.x += 1
	if Input.is_action_pressed("Left"):
		velocity.x -= 1
	velocity = velocity.normalized() * speed

# all code related to shooting handled in this function
func _shootingHandler():
	if Input.is_action_pressed("Shoot") and shotReady: # when the player is trying to shoot and cd is down
		shotReady = false # put bullet on cooldown
		$ShotCooldown.start()
		var newBullet = bullet.instance() # instance a bullet and place it at the fire point
		newBullet.transform = $FirePoint.get_global_transform()
		owner.add_child(newBullet)


func _on_ShotCooldown_timeout():
	shotReady = true
