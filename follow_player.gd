extends Node

@export var speed: float = 1.0
@export var chase_distance = 10000.0  # Distância para iniciar a perseguição
@export var attack_distance = 100.0

var sprite: Sprite2D
var player: Player
var enemy: Enemy
var animations: AnimationPlayer

func _ready():
	enemy = get_parent()
	animations = enemy.get_node("AnimationPlayer")
	sprite = enemy.get_node("SpriteEnemy")

func _physics_process(_delta: float) -> void:
	if GameManager.is_game_over: return
	# Obter a posição do Player a partir do GameManager
	var player_position = GameManager.player_position

	# Calculate difference and direction
	var difference = player_position - enemy.position
	var direction = difference.normalized()

	# Calculate distance to player
	var distance_to_player = enemy.position.distance_to(player_position)

	if distance_to_player > chase_distance:
		enemy.velocity = Vector2.ZERO
		animations.play("idle_enemy")
	elif distance_to_player <= chase_distance and distance_to_player > attack_distance:
		enemy.velocity = direction * speed * 100.0
		enemy.move_and_slide()
		animations.play("run_enemy")
	else:
		animations.play("attack_enemy")

	# Flip sprite
	sprite.flip_h = direction.x < 0
