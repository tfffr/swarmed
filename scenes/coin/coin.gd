class_name Coin
extends Area2D

enum CoinType {Bronze, Jade, Diamond, Sapphire}

var coin_value : Dictionary = {
	CoinType.Bronze: 1,
	CoinType.Jade: 2,
	CoinType.Diamond: 3,
	CoinType.Sapphire: 4,
}

@export var type := CoinType.Bronze

@onready var coin_sprite: Sprite2D = $CoinSprite


func _ready() -> void:
	coin_sprite.frame = type


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.add_coins(_increase_coins_collected_amount())
		queue_free()


func _increase_coins_collected_amount() -> int:
	return coin_value[type]
