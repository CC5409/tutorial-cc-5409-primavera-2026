class_name UIPlayerCoins
extends HBoxContainer


@onready var name_label: Label = %NameLabel
@onready var coins_label: Label = %CoinsLabel

var _player_data: Statics.PlayerData


func setup(player_data: Statics.PlayerData) -> void:
	_player_data = player_data
	name_label.text = player_data.name
	coins_label.text = str(player_data.coins)
	player_data.coins_changed.connect(_on_coins_changed)


func _on_coins_changed(value: int) -> void:
	coins_label.text = str(value)
