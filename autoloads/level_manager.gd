class_name LevelManager
extends Node


static var instance: LevelManager

var main: Main

@export var levels: Dictionary[String, LevelData]

@export var credits: PackedScene

var current_level: String


func _enter_tree() -> void:
	instance = self


func _ready() -> void:
	
	load_levels()


func load_levels() -> void:
	var path: String = "res://levels/data/"
	var level_data_paths: PackedStringArray = ResourceLoader.list_directory(path)
	for level_data_path: String in level_data_paths:
		var level_data: LevelData = ResourceLoader.load(path + level_data_path)
		levels[level_data_path.split(".")[0]] = level_data


func next_level() -> void:
	go_to_level("level_02")
	#else:
		#go_to_credits()


func go_to_level(level_id: String) -> void:
	current_level = level_id
	main.spawn_level(current_level)


func get_level(id: String) -> PackedScene:
	return levels[id].scene


func go_to_credits() -> void:
	if not credits:
		return
	Lobby.instance.reset()
	get_tree().change_scene_to_packed(credits)
