class_name World
extends Node2D

@onready var player: Player = $Player
@onready var progress_bar: ProgressBar = $ProgressBar


func _physics_process(_delta: float) -> void:
	progress_bar.value = player.current_stamina
