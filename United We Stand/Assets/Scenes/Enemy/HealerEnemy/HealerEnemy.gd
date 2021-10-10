extends "res://Assets/Scenes/Enemy/EnemyBase.gd"

# Declare member variables here.
export var healAmount = 2

var _healTargets = [] # array containing which enemies will get healed

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()

func _process(delta):
	._process(delta)



# when a body enters the healing radius...
func _on_HealZone_body_entered(body):
	# if it's an enemy,
	if(body.is_in_group("enemies")):
		# add it to the list of enemies to be healed
		_healTargets.push_back(body)
		print("healer has found a new patient")


# when a body leaves the healing radius...
func _on_HealZone_body_exited(body):
	# take it off the heal list
	_healTargets.erase(body)

func castHeal():
	for friend in _healTargets:
		friend.takeDamage(-1 * healAmount)
