class_name UIPlayerInfo
extends HBoxContainer


@onready var name_label: Label = %NameLabel
@onready var health_bar: ProgressBar = %HealthBar
@onready var coins_label: Label = %CoinsLabel

var _player_data: Statics.PlayerData


func setup(player_data: Statics.PlayerData) -> void:
	_player_data = player_data
	name_label.text = player_data.name
	coins_label.text = str(player_data.coins)
	player_data.coins_changed.connect(_on_coins_changed)
	var player: Player = _player_data.instance
	if player:
		player.health_changed.connect(_on_health_changed)
		health_bar.value = player.health_component.health
		health_bar.max_value = player.health_component.max_health


func _on_coins_changed(value: int) -> void:
	coins_label.text = str(value)


func _on_health_changed(value: float) -> void:
	health_bar.value = value
