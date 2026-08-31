extends Node3D


@onready var animation_player: AnimationPlayer = $Model/tower/AnimationPlayer
@onready var interaction_area: InteractionArea = $InteractionArea

# server only
var _door_opened: bool = false
# server only
var _updating_door: bool = false


func _ready() -> void:
	interaction_area.interact.connect(_request_interaction)


func _request_interaction() -> void:
	_execute_interaction.rpc_id(1)


# server only
@rpc("any_peer", "call_local")
func _execute_interaction() -> void:
	if _updating_door:
		return
	_updating_door = true
	_update_door.rpc(not _door_opened)
	await animation_player.animation_finished
	_door_opened = not _door_opened
	_updating_door = false


@rpc("call_local")
func _update_door(open: bool) -> void:
	if open:
		animation_player.play("open")
	else:
		animation_player.play_backwards("open")
