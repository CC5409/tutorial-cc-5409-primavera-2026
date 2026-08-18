extends Area3D


@export var move_speed: float = 3


func _ready() -> void:
	set_multiplayer_authority(get_parent().owner.get_multiplayer_authority())
	
	await get_tree().create_timer(3).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	var direction: Vector3 = -basis.z
	var velocity: Vector3 = direction * move_speed
	position += velocity * delta
