class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 3

@export_category("Sword")
@export var swordDamage: int = 2

@export_category("Ritual")
@export var explosionDamage: int = 1
@export var explosionInterval: float = 30
@export var explosionScene: PackedScene

@export_category("Life")
@export var health: int = 100
@export var maxHealth: int = 100
@export var deathPrefab: PackedScene


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2d
@onready var swordArea: Area2D = $SwordArea
@onready var hitBoxArea: Area2D = $HitBox
@onready var healthProgressionBar: ProgressBar = $HealthProgressBar

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitBoxCD: float = 0.0
var explosionCD: float = 0.0

signal meatCollected(value:int) 

func _ready():
	GameManager.player = self
	meatCollected.connect(func(value:int): 
		GameManager.meatCounter += 1
		)

func _process(delta):
	GameManager.playerPosition = position
	
	read_input()
	
	# Processar Ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# Processar animação de rotação de sprite
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
	
	# Processar dano
	updateHitBoxDetection(delta)
	
	# Explosão
	updateExplosion(delta)
	
	# Atualizar Heath Bar
	healthProgressionBar.max_value = maxHealth
	healthProgressionBar.value = health
	
func _physics_process(delta):
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
		
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

func update_attack_cooldown(delta):
	# Atualizar Temporizador de Ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func updateExplosion(delta):
	# atualizar temporizador
	explosionCD -= delta
	if explosionCD > 0: return
	# resetar temporizador
	explosionCD = explosionInterval
	
	# criar explosao
	var explosion = explosionScene.instantiate()
	explosion.damageAmount = explosionDamage
	add_child(explosion)


func read_input():
	# Obter Input Vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Apagar Dead Zone do Input_Vector
	var deadZone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
		
	# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()


func play_run_idle_animation():
	# Tocar Animação
	if not is_attacking:
		if was_running != is_running:
			if is_running: 
				animation_player.play("run")
			else:
				animation_player.play("idle")


func rotate_sprite():
		# Girar Sprite
	if input_vector.x > 0:
		#desmarcar flip_h do Sprite2D
		sprite.flip_h = false
	elif input_vector.x < 0:
		#marcar flip_h do Sprite2D
		sprite.flip_h = true


func attack():
	if is_attacking:
		return
	# Attack A
	# Attack B
	# Tocar Animação
	animation_player.play("attack_a")
	attack_cooldown = 0.6
	# Marcar Ataque
	is_attacking = true
	# Aplicar Dano aos Inimigos


func dealDamageToEnemys():
	var bodies = swordArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var directionToEnemy = (enemy.position - position).normalized()
			var atackDirection: Vector2
			if sprite.flip_h:
				atackDirection = Vector2.LEFT
			else:
				atackDirection = Vector2.RIGHT
			var dotProduct = directionToEnemy.dot(atackDirection)
			if dotProduct >= 0.3:
				enemy.damage(swordDamage)
				print(dotProduct)

func updateHitBoxDetection(delta: float):
	# Temporizador
	hitBoxCD -= delta
	if hitBoxCD > 0: return
	
	# Frequencia
	hitBoxCD = 0.5
	
	# Detectar Inimigos
	var bodies = hitBoxArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damageAmount = 1
			damage(damageAmount)

func damage(amount: int):
	if health <= 0: return
	
	health -= amount
	print("Player recebeu: " ,amount, " sua vida total é de: ", health)
	
	# Piscar Inimigo
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

	# Processar Morte
	if health <= 0.0:
		die()

func die():
	if deathPrefab:
		GameManager.endGame()
		var deathObject = deathPrefab.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
		print("GAME OVER!")
	queue_free()

func heal(amount: int):
	health += amount
	if health > maxHealth:
		health = maxHealth
	print(amount," ", health, "/" , maxHealth)
	return health
