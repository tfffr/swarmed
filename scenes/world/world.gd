class_name World
extends Node2D

const BULLET_BLUEPRINT := preload("res://scenes/bullet/bullet.tscn")

@onready var player: Player = $Player
@onready var stamina_bar: Control = $CanvasLayer/UI/ProgressBar


func _physics_process(_delta: float) -> void:
	stamina_bar.value = player.current_stamina


func _on_player_shot(
	bullet_global_position: Vector2, bullet_global_rotation: float
) -> void:
	var bullet: Bullet = BULLET_BLUEPRINT.instantiate()
	add_child(bullet)
	bullet.global_position = bullet_global_position
	bullet.global_rotation = bullet_global_rotation
