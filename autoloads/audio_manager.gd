extends Node

func play_sfx(stream: AudioStream, pos: Vector3) -> void:
	var player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	player.stream = stream
	player.bus = &"SFX"
	add_child(player)
	player.global_position = pos
	player.play()
	await player.finished
	player.queue_free()
