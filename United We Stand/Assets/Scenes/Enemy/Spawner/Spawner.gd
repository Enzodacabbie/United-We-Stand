extends Area2D


# Declare member variables here. Examples:
export (PackedScene) var enemyType
export var maxEnemies = 5
var currentEnemies = 0

var maxDistance

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	maxDistance = $SpawnArea.shape.radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _spawnEnemy():
	var spawnPos = position
	var distanceFromCenter:Vector2 = Vector2(0, maxDistance + 25)
	while distanceFromCenter.length_squared() > maxDistance * maxDistance:
		distanceFromCenter = Vector2(random.randi_range(0,maxDistance),random.randi_range(0,maxDistance))
	spawnPos = spawnPos + distanceFromCenter
	
	var newEnemy = enemyType.instance()
	newEnemy.position = spawnPos
	get_parent().add_child(newEnemy)

func _on_SpawnTimer_timeout():
	if currentEnemies < maxEnemies:
		_spawnEnemy()
	var newCooldown = random.randi_range(10,30)
	$SpawnTimer.wait_time = newCooldown
	$SpawnTimer.start()


func _on_Spawner_body_entered(body):
	if body.is_in_group("enemies"):
		currentEnemies = currentEnemies + 1


func _on_Spawner_body_exited(body):
	if body.is_in_group("enemies"):
		currentEnemies = currentEnemies - 1
