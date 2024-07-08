extends CanvasLayer

@onready var timerLabel: Label = %"Timer Label"
#@onready var goldLabel: Label = %"Gold Label"
@onready var meatLabel: Label = %"Meat label"


func _process(delta):
	# Update Timer
	timerLabel.text = GameManager.timeLapseString
	meatLabel.text = str(GameManager.meatCounter)
