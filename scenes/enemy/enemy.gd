class_name Enemy
extends CharacterBody2D

enum EnemyState {Walking, Hurting, Dying}

signal damage_received(damage_global_position: Vector2, damage: int)
signal splash_damage(enemy_global_position: Vector2, amount: int, reward_type: Coin.CoinType)

@export var player: Player = null
@export var speed: float = 10.
@export var max_health: int = 15
@export var reward := Coin.CoinType.Bronze

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var damage_label_spawn: Node2D = $DamageLabelSpawn
@onready var current_health := max_health

var current_state := EnemyState.Walking


func _ready() -> void:
	timer.start(randf_range(0., 0.6))
	progress_bar.max_value = max_health
	progress_bar.value = current_health


func _physics_process(_delta: float) -> void:
	if player == null:
		print("No player assigned to enemy!")
		return
	if current_state != EnemyState.Walking:
		velocity = Vector2.ZERO
	else:
		var direction := position.direction_to(player.position)
		enemy_sprite.flip_h = direction.x < 0.
		velocity = direction * speed
	move_and_slide()


func _on_timer_timeout() -> void:
	_walk()


func _walk() -> void:
	current_state = EnemyState.Walking
	animation_player.play("walk")


func _on_bullet_detection_area_body_entered(body: Node2D) -> void:
	if !body is Bullet:
		return
	var bullet: Bullet = body
	get_hurt(bullet.damage)
	bullet.queue_free()


func get_hurt(damage: int) -> void:
	_hurt(damage)
	var extra_damage := damage - current_health
	_die(extra_damage)


func _hurt(damage: int) -> void:
	if current_state == EnemyState.Dying || damage == 0:
		return
	current_state = EnemyState.Hurting
	current_health = clamp(current_health - damage, 0, max_health)
	progress_bar.value = current_health
	animation_player.play("hurt")
	damage_received.emit(damage_label_spawn.global_position, damage)


func _die(extra_damage: int) -> void:
	if current_health == 0:
		current_state = EnemyState.Dying
		extra_damage /= 2
		splash_damage.emit(global_position, extra_damage, reward)
		animation_player.stop()
		queue_free()
