extends Area3D


@export var min_players: int = 2
var player_count: int = 0
@onready var label_3d: Label3D = $Label3D
@onready var timer: Timer = $Timer


func _ready() -> void:
	label_3d.hide()
	if multiplayer.is_server():
		body_entered.connect(_on_body_entered)
		body_exited.connect(_on_body_exited)
		timer.timeout.connect(_on_timer_timeout)


func _process(_delta: float) -> void:
	label_3d.text = "%d" % ceil(timer.time_left)


func _on_body_entered(body: Node3D) -> void:
	var player: Player = body as Player
	if player:
		player_count += 1
		if player_count >= min_players:
			multicast_timer.rpc(true)


func _on_body_exited(body: Node3D) -> void:
	var player: Player = body as Player
	if player:
		player_count -= 1
		if player_count < min_players:
			multicast_timer.rpc(false)


@rpc("call_local")
func multicast_timer(start: bool) -> void:
	if start:
		timer.start()
		label_3d.show()
	else:
		timer.stop()
		label_3d.hide()


func _on_timer_timeout() -> void:
	LevelManager.instance.next_level()
