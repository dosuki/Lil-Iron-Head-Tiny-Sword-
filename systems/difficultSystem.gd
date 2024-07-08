extends Node

@export var mobSpawner: mobSpawner
@export var initialSpawnRate: float = 60
@export var spawnRatePerMin: float = 30
@export var waveDuration: float = 20
@export var breakIntensity: float = 0.5

var time: float = 0.0


func _process(delta):
	# Game Over
	if GameManager.isGameOver: return
	
	# Temporizador
	time += delta
	
	# Linha Verde: dificuldade linear
	var spawnRate = initialSpawnRate + spawnRatePerMin * (time / 60.0)
	
	# Sistema de ondas: linha rosa
	var sinWave = sin((time * TAU) / waveDuration)
	var waveFactor = remap(sinWave, -1.0, 1.0, breakIntensity, 1)

	spawnRate *= waveFactor
	
	# Aplicar Dificuldade	
	mobSpawner.mobsPerMinute  = spawnRate
