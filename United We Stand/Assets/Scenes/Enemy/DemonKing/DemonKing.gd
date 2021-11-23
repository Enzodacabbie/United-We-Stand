extends RigidBody2D


# Declare member variables here.
var random = RandomNumberGenerator.new()

var player

export var maxHP = 300
var _HP

var fireSpawners = []
var haloSpawners = []
var targets = []

var wavesLeft = 0

var attackReady = false

export (PackedScene) var teardropBullet
export (PackedScene) var normalBullet
export (PackedScene) var waveBullet
export (PackedScene) var bombBullet

export (AudioStream) var hurtSound

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	player = get_parent().get_node("Player")
	
	fireSpawners = [
		$FlameSpawner1,
		$FlameSpawner2,
		$FlameSpawner3,
		$FlameSpawner4
	]
	
	haloSpawners = [
		$HaloSpawner1,
		$HaloSpawner2,
		$HaloSpawner3,
		$HaloSpawner4,
		$HaloSpawner5,
		$HaloSpawner6,
		$HaloSpawner7,
		$HaloSpawner8
	]
	
	targets = [
		$Target1,
		$Target2,
		$Target3,
		$Target4,
		$Target5,
		$Target6,
		$Target7,
		$Target8
	]
	
	_HP = maxHP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attack()
	_tryDying()

func attack():
	if attackReady:
		var whichAttack = random.randi_range(0,1)
		if whichAttack == 1:
			wavesLeft = 3
		else:
			_shootBomb()
		
		attackReady = false
		$AttackTimer.start()

func _on_FireballTimer_timeout():
	_shootTeardrop()

func _shootTeardrop():
	var newBullet = teardropBullet.instance()
	var spawnerIndex = random.randi_range(0,3)
	newBullet.position = fireSpawners[spawnerIndex].global_position
	newBullet.direction = fireSpawners[spawnerIndex].global_position.direction_to(player.global_position)
	get_parent().add_child(newBullet)

func _shootWave():
	var newBullet = waveBullet.instance()
	var spawnerIndex = random.randi_range(0,7)
	newBullet.position = haloSpawners[spawnerIndex].global_position
	newBullet.initialDirection = haloSpawners[spawnerIndex].global_position.direction_to(player.global_position)
	get_parent().add_child(newBullet)

func _shootBomb():
	var newBullet = bombBullet.instance()
	var spawnerIndex = random.randi_range(0,7)
	var targetIndex = random.randi_range(0,7)
	newBullet.position = haloSpawners[spawnerIndex].global_position
	newBullet.targetPosition = targets[targetIndex].global_position
	get_parent().add_child(newBullet)

func takeDamage(var amount):
	_HP = clamp(_HP - amount, 0, maxHP)
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.set_stream(hurtSound)
	audioPlayer.set_volume_db(-8)
	get_parent().add_child(audioPlayer)
	audioPlayer.play()

func _tryDying():
	if _HP == 0:
		get_tree().change_scene("res://Assets/Scenes/Game/Victory Scene.tscn")

func _on_WaveTimer_timeout():
	if wavesLeft > 0:
		wavesLeft = clamp(wavesLeft - 1, 0, 10)
		_shootWave()


func _on_AttackTimer_timeout():
	attackReady = true
