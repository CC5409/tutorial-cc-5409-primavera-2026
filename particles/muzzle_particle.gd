extends Node3D

@onready var rings: GPUParticles3D = $Rings

func _ready() -> void:
	rings.finished.connect(queue_free)
