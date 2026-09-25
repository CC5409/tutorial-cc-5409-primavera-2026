extends CanvasLayer


@onready var save_game: Button = %SaveGame
@onready var load_game: Button = %LoadGame


func _ready() -> void:
	save_game.pressed.connect(Game.instance.save_game)
	load_game.pressed.connect(Game.instance.load_game)
	hide()
	set_process_input(multiplayer.is_server())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		visible = not visible
