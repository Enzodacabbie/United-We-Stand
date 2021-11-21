extends AllyBase


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var healAmount = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("scored_takedown", self, "_castHeal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _castHeal():
	player.call("takeDamage", -healAmount)
