class_name Main
extends Node3D


@onready var level_spawner: MultiplayerSpawner = $LevelSpawner
@onready var levels: Node3D = $Levels


func _enter_tree() -> void:
	LevelManager.instance.main = self


func _ready() -> void:
	level_spawner.spawn_function = _spawn_level
	
	if multiplayer.is_server():
		await get_tree().create_timer(0.2).timeout
		spawn_level("level_selector")


func _spawn_level(data: Dictionary) -> Node:
	if not "level_id" in data:
		return null
	var level_id: String = data.level_id
	var level_instance: Node = LevelManager.instance.get_level(level_id).instantiate()
	return level_instance


func spawn_level(level_id: String) -> void:
	for child: Node in levels.get_children():
		child.get_parent().remove_child(child)
		child.queue_free()
	level_spawner.spawn({"level_id": level_id})
