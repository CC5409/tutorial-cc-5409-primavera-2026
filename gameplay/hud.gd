extends CanvasLayer


const PLAYER_INFO: PackedScene = preload("uid://dseeom5f4qics")

@onready var player_info_container: VBoxContainer = %PlayerInfoContainer

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	for player_data: Statics.PlayerData in Game.instance.players:
		var player_coins: UIPlayerInfo = PLAYER_INFO.instantiate()
		player_info_container.add_child(player_coins)
		player_coins.setup(player_data)
