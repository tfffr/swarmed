class_name Player
extends CharacterBody2D

const BULLET_BLUEPRINT := preload("res://scenes/bullet/bullet.tscn")

enum PlayerState {Idle, Moving, Shooting}

@export var normal_speed := 60
@export var max_speed := 120
@export var max_stamina := 100.
@export var fire_rate := 3.

@onready var sprite_body: Sprite2D = $SpriteBody
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon: Weapon = $SpriteBody/WeaponPivot/Weapon
@onready var weapon_pivot: Node2D = $SpriteBody/WeaponPivot
@onready var shot_timer: Timer = $ShotTimer
@onready var bullet_spawn_location: Node2D = $SpriteBody/WeaponPivot/Weapon/BulletSpawnLocation

var current_state := PlayerState.Idle
var current_speed := normal_speed
var current_stamina := max_stamina


func _ready() -> void:
	_set_fire_rate()


func _set_fire_rate() -> void:
	shot_timer.start(1. / fire_rate)
	

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	_choose_state(direction)
	_choose_flip()
	_aim_at(get_global_mouse_position())
	velocity = direction * current_speed
	move_and_slide()


func _aim_at(target: Vector2) -> void:
	var weapon_direction := weapon_pivot.global_position.direction_to(target)
	weapon_pivot.rotation = weapon_direction.angle()


func _choose_state(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		_idle()
	else:
		_move()
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#_shoot()


func _idle() -> void:
	current_state = PlayerState.Idle
	animation_player.play("idle")


func _move() -> void:
	current_state = PlayerState.Moving
	if Input.is_action_pressed("sprint"):
		_sprint()
	else:
		_walk()
	animation_player.play("move")


func _sprint() -> void:
	current_speed = max_speed
	_decrease_stamina()
	if current_stamina == 0:
		current_speed = normal_speed


func _walk() -> void:
	current_speed = normal_speed
	_increase_stamina()


func _decrease_stamina() -> void:
	current_stamina -= 1
	if current_stamina < 0:
		current_stamina = 0


func _increase_stamina() -> void:
	current_stamina += 1
	if current_stamina > max_stamina:
		current_stamina = max_stamina


func _shoot() -> void:
	current_state = PlayerState.Shooting
	weapon.animation_player.play("shoot")
	var bullet: Bullet = BULLET_BLUEPRINT.instantiate()
	bullet.position = bullet_spawn_location.position
	bullet.rotation = weapon_pivot.rotation
	add_child(bullet)


func _choose_flip() -> void:
	if get_global_mouse_position().x < position.x:
		_flip_left()
	else:
		_flip_right()


func _flip_left() -> void:
	sprite_body.flip_h = true
	weapon_pivot.scale.y = -1.
	weapon.position.x = 6.
	sprite_shadow.position.x = 2.
	collision_shape_2d.position.x = 1.


func _flip_right() -> void:
	sprite_body.flip_h = false
	weapon_pivot.scale.y = 1.
	weapon.position.x = 4.
	sprite_shadow.position.x = 0.
	collision_shape_2d.position.x = -1.


func _on_shot_timer_timeout() -> void:
	_shoot()
