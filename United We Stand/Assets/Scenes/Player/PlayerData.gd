extends Node


# Declare member variables here.
var maxHP
var hp

var allies = []


enum allyType {
	HEALER,
	ARCHER,
	MAGE
}

var allyScene = [
	preload("res://Assets/Scenes/Ally/HealerAlly/HealerAlly.tscn"),
	preload("res://Assets/Scenes/Ally/ShooterAlly/ArcherAlly/ArcherAlly.tscn"),
	preload("res://Assets/Scenes/Ally/ShooterAlly/MageAlly/MageAlly.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func newGame():
	maxHP = null
	hp = null
	allies = []
