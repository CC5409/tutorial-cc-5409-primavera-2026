extends Area3D

const COIN: AudioStream = preload("uid://dlhboqrhogatm")

func _ready() -> void:
	if multiplayer.is_server():
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	var player: Player = body as Player
	if player:
		Game.instance.add_coins(player.get_multiplayer_authority(), 1)
		pickup_broadcast.rpc()


@rpc("call_local")
func pickup_broadcast() -> void:
	AudioManager.play_sfx(COIN, global_position)
	queue_free()
