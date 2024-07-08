class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int = 10
@export var deathPrefab: PackedScene
var damageDigitPrefab: PackedScene

@onready var damageDigitMarker = $damageDigitMarker

@export_category("Drops")
@export var dropChance: float = 0.1
@export var dropTable: Array[PackedScene]
@export var dropChances: Array[float]

func _ready():
	damageDigitPrefab = preload("res://misc/damageDigit.tscn")

func damage(amount: int):
	health -= amount
	print("inimigo recebeu: " ,amount, " sua vida total é de: ", health)
	
	# Piscar Inimigo
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Criar DamageDigit
	var damageDigit = damageDigitPrefab.instantiate()
	damageDigit.value = amount
	if damageDigitMarker:
		damageDigit.global_position = damageDigitMarker.global_position
	else:
		damageDigitMarker.global_position = global_position
	get_parent().add_child(damageDigit)

	# Processar Morte
	if health <= 0.0:
		die()
		

func die():
	# Caveira
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
	# Drop
	if randf() <= dropChance:
		dropItem()

	# Incrementar Contador
	GameManager.monstersDefeatedCounter += 1
	
	# Deletar node
	queue_free()
		
func dropItem():
	var drop = getRandomDropItem().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	
func getRandomDropItem() -> PackedScene: 
	# Listas com 1 Item
	if dropTable.size() == 1:
		return dropTable[0]
	
	# calcular chance máxima
	var maxChance: float = 0.0
	for dropChance in dropChances:
		maxChance += dropChance
		
	# jogar dado
	var randomValue = randf() * maxChance
	
	# girar a roleta
	var needle: float = 0
	for i in dropTable.size():
		var dropItem = dropTable[i]
		var dropChance = dropChances[i] if i < dropChances.size() else 1
		if randomValue <= dropChance + needle:
			return dropItem
		needle += dropChance
		
	return dropTable[0]
	pass
		
		
