extends Node3D

@onready var door_button: DoorButton = $DoorButton

@onready var door: Door = $House/Door
@onready var door_2: Door = $House/Door2
@onready var mesh_instance_3d: MeshInstance3D = $Floor/MeshInstance3D

var opened: bool = false

func _ready() -> void:
	door_button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	if opened:
		door.close()
		door_2.close()
	else:
		door.open()
		door_2.open()
	opened = not opened
	mesh_instance_3d.material_override.albedo_color = Color(randf(), randf(), randf(), 1.0)
