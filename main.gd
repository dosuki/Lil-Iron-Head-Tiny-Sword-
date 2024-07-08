extends Node

@export var gameUI: CanvasLayer
@export var gameOverUITemplate: PackedScene

func _ready():
	GameManager.gameOver.connect(triggerGameOver)

func triggerGameOver():
	# Deletar GameUI
	gameUI.queue_free()
	gameUI = null
	
	# Criar GameOverUi
	var gameOverUI: GameOverUI = gameOverUITemplate.instantiate()
	add_child(gameOverUI)

