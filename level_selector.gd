class_name LevelSelector
extends Control


const LEVEL_CARD: PackedScene = preload("uid://sejabyy3h7je")
@onready var grid_container: GridContainer = $VBoxContainer/GridContainer


func _ready() -> void:
	for id: String in LevelManager.instance.levels:
		var level_data: LevelData = LevelManager.instance.levels[id]
		if level_data.debug_only:
			continue
		var level_card_inst: LevelCard = LEVEL_CARD.instantiate()
		grid_container.add_child(level_card_inst)
		level_card_inst.setup(id, level_data)
