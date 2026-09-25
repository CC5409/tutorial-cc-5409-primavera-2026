extends CanvasLayer


const PLAYER_COINS: PackedScene = preload("uid://dseeom5f4qics")

@onready var player_coins_container: VBoxContainer = %PlayerCoinsContainer

func _ready() -> void:
	for player_data: Statics.PlayerData in Game.instance.players:
		var player_coins: UIPlayerCoins = PLAYER_COINS.instantiate()
		player_coins_container.add_child(player_coins)
		player_coins.setup(player_data)
