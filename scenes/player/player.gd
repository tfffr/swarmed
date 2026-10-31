class_name Player
extends CharacterBody2D

@export var speed := 120

enum PlayerState {Idle, Moving}

@onready var sprite_body: Sprite2D = $SpriteBody
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_state := PlayerState.Idle


func _physics_process(delta: float) -> void:
	if Input.is_anything_pressed():
		_move(delta)
	else:
		_idle()
	move_and_slide()


func _idle() -> void:
	current_state = PlayerState.Idle
	animation_player.stop()


func _move(delta) -> void:
	current_state = PlayerState.Moving
	animation_player.play("move")
	change_position(delta)


func change_position(delta) -> void:
	if Input.is_action_pressed("move_down"):
		position.y += speed * delta
	if Input.is_action_pressed("move_up"):
		position.y -= speed * delta
	if Input.is_action_pressed("move_left"):
		_go_left(delta)
	if Input.is_action_pressed("move_right"):
		_go_right(delta)


func _go_left(delta) -> void:
	sprite_body.flip_h = true
	sprite_shadow.position.x = 2.
	collision_shape_2d.position.x = 1.
	position.x -= speed * delta


func _go_right(delta) -> void:
	sprite_body.flip_h = false
	sprite_shadow.position.x = 0.
	collision_shape_2d.position.x = -1.
	position.x += speed * delta
