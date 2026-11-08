class_name World
extends Node2D

const BULLET_BLUEPRINT := preload("res://scenes/bullet/bullet.tscn")
const DAMAGE_LABEL_INDICATOR_BLUEPRINT := preload(
	"res://scenes/damage_label_indicator/damage_label_indicator.tscn"
)
const EXPLOSION_BLUEPRINT := preload("res://scenes/explosion/explosion.tscn")
const ENEMY_BLUEPRINT := preload("res://scenes/enemy/enemy.tscn")

@onready var player: Player = $Player
@onready var stamina_bar: Control = $CanvasLayer/UI/ProgressBar


func _ready() -> void:
	_spawn_enemies()


func _physics_process(_delta: float) -> void:
	stamina_bar.value = player.current_stamina


func _spawn_enemies() -> void:
	for i in 20:
		var enemy: Enemy = ENEMY_BLUEPRINT.instantiate()
		enemy.damage_received.connect(_on_enemy_damage_received)
		enemy.splash_damage.connect(_on_enemy_splash_damage)
		enemy.player = player
		enemy.global_position = player.get_random_spawn_position()
		add_child(enemy)


func _on_player_shot(
	bullet_global_position: Vector2,
	bullet_global_rotation: float,
	bullet_damage: int
) -> void:
	var bullet: Bullet = BULLET_BLUEPRINT.instantiate()
	add_child(bullet)
	bullet.global_position = bullet_global_position
	bullet.global_rotation = bullet_global_rotation
	bullet.damage = bullet_damage


func _on_enemy_damage_received(
	damage_global_position: Vector2, damage: int
) -> void:
	var damage_label_indicator: DamageLabelIndicator = (
		DAMAGE_LABEL_INDICATOR_BLUEPRINT.instantiate()
	)
	add_child(damage_label_indicator)
	damage_label_indicator.global_position = damage_global_position
	damage_label_indicator.set_damage(damage)


func _on_enemy_splash_damage(enemy_position: Vector2, amount: int) -> void:
	var explosion: Explosion = EXPLOSION_BLUEPRINT.instantiate()
	explosion.splash_damage = amount
	explosion.global_position = enemy_position
	add_child.call_deferred(explosion)
