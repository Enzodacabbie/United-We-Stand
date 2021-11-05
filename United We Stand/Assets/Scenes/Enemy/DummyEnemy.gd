extends EnemyBase


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	takeDamage(5) # to test healing, since healing can't increase past max


func _process(_delta):
	_updateHPBar()

# the dummy enemy has an hp bar. This function makes that hp bar update.
func _updateHPBar():
	$hpbar.text = _HP as String
