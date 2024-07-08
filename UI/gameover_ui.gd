class_name GameOverUI
extends CanvasLayer

@onready var timeLabel: Label = %TimeLabel
@onready var monstersLabel: Label = %MonstersLabel

@export var restartDelay = 5.0
var restartCD: float

func _ready():
	timeLabel.text = GameManager.timeLapseString
	monstersLabel.text = str(GameManager.monstersDefeatedCounter)
	restartCD = restartDelay
	
func _process(delta):
	restartCD -= delta
	if restartCD <= 0.0:
		restartGame()
			
func restartGame():
	GameManager.reset()
	get_tree().reload_current_scene()
