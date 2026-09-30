@tool
extends Node3D

@onready var suzanne: MeshInstance3D = $monkey_smooth/Suzanne

@export var test: bool:
	set(value):
		test = value
		if suzanne:
			suzanne.material_override.set("shader_parameter/fresnel_enabled", test)
