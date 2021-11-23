extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	PlayerData.newGame()
	get_tree().change_scene("res://Assets/Scenes/Game/Overworld Scene.tscn")



func _on_Button2_pressed():
	get_tree().quit()
