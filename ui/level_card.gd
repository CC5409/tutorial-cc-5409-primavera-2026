class_name LevelCard
extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $TextureRect/Label


var id: String

func _ready() -> void:
	pressed.connect(_on_button_pressed)


func setup(level_id: String, level_data: LevelData) -> void:
	texture_rect.texture = level_data.image
	label.text = level_data.name
	id = level_id


func _on_button_pressed() -> void:
	request_level.rpc_id(1)


@rpc("call_local", "any_peer")
func request_level() -> void:
	LevelManager.instance.go_to_level(id)
