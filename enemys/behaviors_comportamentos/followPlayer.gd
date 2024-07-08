extends Node

@export var speed: float = 1

var enemy: Enemy
var sprite: AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	
	

func _physics_process(delta):
	# Game Over
	if GameManager.isGameOver: return
	# Calcular direção
	var playerPosition = GameManager.playerPosition
	var difference = playerPosition - enemy.position
	var input_vector = difference.normalized()
	
	# Movimento
	enemy.velocity = speed * input_vector * 100
	enemy.move_and_slide()
	
		# Girar Sprite
	if input_vector.x > 0:
		#desmarcar flip_h do Sprite2D
		sprite.flip_h = false
	elif input_vector.x < 0:
		#marcar flip_h do Sprite2D
		sprite.flip_h = true
