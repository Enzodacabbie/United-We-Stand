extends RigidBody2D
class_name EnemyBase

# Declare member variables here.
export var maxHP = 5
var _HP


# Called when the node enters the scene tree for the first time.
func _ready():
	_HP = maxHP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tryDying()

# This function is intended to be called by other entities.
# Decrements the enemy's current HP by amount (negative values will heal)
func takeDamage(var amount):
	_HP = clamp(_HP - amount, 0, maxHP)

func _tryDying():
	if (_HP == 0):
		queue_free()

