extends AllyBase


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var healAmount = 1
export (AudioStream) var healSound

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("scored_takedown", self, "_castHeal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _castHeal():
	player.call("takeDamage", -healAmount)
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.set_stream(healSound)
	audioPlayer.set_volume_db(-8)
	get_parent().add_child(audioPlayer)
	audioPlayer.play()
