extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
export var message = ""
export (PackedScene) var allyType


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact(player):
	print(message)
	player.call("spawnAlly", allyType, position, false)

func toggleOff():
	$Sprite.scale.y = -1

func toggleOn():
	$Sprite.scale.y = 1
