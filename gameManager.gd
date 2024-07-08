extends Node

signal gameOver

var playerPosition: Vector2
var player: Player
var isGameOver: bool = false

var timeLapse: float = 0.0
var timeLapseString: String
var meatCounter: int = 0
var monstersDefeatedCounter: int = 0

func _process(delta):
	# Update Timer
	timeLapse += delta
	var timeLapseSeconds: int = floori(timeLapse)
	var seconds: int = timeLapseSeconds % 60
	var minutes: int = timeLapseSeconds / 60
	timeLapseString = "%02d:%02d" % [minutes, seconds]

func endGame():
	if isGameOver: return
	isGameOver = true
	gameOver.emit()
	
func reset():
	player = null
	playerPosition = Vector2.ZERO
	isGameOver = false
	
	timeLapse = 0.0
	timeLapseString = "00:00"
	meatCounter = 0
	monstersDefeatedCounter = 0
	
	for connection in gameOver.get_connections():
		gameOver.disconnect(connection.callable)
