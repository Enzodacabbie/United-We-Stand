extends RigidBody2D
class_name EnemyBase

# Declare member variables here.
export var maxHP = 5
var _HP

var random = RandomNumberGenerator.new()

enum allyType {
	HEALER,
	ARCHER,
	MAGE
}

export (AudioStream) var hurtSound
export (AudioStream) var deathSound

export var sendToFront = false

export (PackedScene) var defeated
export (allyType) var type

export (StreamTexture) var defeatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	_HP = maxHP
	random.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tryDying()

# movement has to be called in _integrate_forces in order to safely access physics state
func _integrate_forces(state):
	_movementHandler(state)

# This function is intended to be called by other entities.
# Decrements the enemy's current HP by amount (negative values will heal)
# returns true if the enemy dies
func takeDamage(var amount):
	_HP = clamp(_HP - amount, 0, maxHP)
	
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.set_stream(hurtSound)
	audioPlayer.set_volume_db(-8)
	get_parent().add_child(audioPlayer)
	audioPlayer.play()
	
	if _HP == 0:
		return true
	else:
		return false

# virtual function for handling movement, ensure that you overrride
func _movementHandler(state: Physics2DDirectBodyState):
	pass

func _tryDying():
	if (_HP == 0):
		var bodyRandomVariable = random.randi_range(0,3)
		if bodyRandomVariable == 0:
			var deadBody = defeated.instance()
			deadBody.position = position
			deadBody.allyType = type
			deadBody.sendToFront = sendToFront
			deadBody.get_node("Sprite").texture = defeatedSprite
			get_parent().add_child(deadBody)
		var audioPlayer = AudioStreamPlayer.new()
		audioPlayer.set_stream(deathSound)
		audioPlayer.set_volume_db(-20)
		get_parent().add_child(audioPlayer)
		audioPlayer.play()
		queue_free()

