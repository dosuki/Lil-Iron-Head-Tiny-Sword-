class_name mobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
var mobsPerMinute: float = 60.0

@onready var pathFollow2D: PathFollow2D = %PathFollow2D
var cooldown: float = 0.0


#func _ready():
	#var pathFollow2D = %PathFollow2D

func _process(delta):
	# Game Over
	if GameManager.isGameOver: return
	# temporizador (cooldown)
	cooldown -= delta
	if cooldown > 0: return
	
	# frequencia Monstros/minuto
	var interval = 60.0 / mobsPerMinute
	cooldown = interval
	
	# Checar se o ponto é valido
	var point = getPoint()
	var worldState = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result: Array = worldState.intersect_point(parameters, 1)
	if not result.is_empty(): return
	
	# Instanciar criaturas aleatórias
	var index = randi_range(0,creatures.size()-1)
	var creatureScene = creatures[index]
	var creature = creatureScene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)
	

func getPoint():
	pathFollow2D.progress_ratio = randf() #random float
	return pathFollow2D.global_position
