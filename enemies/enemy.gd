extends CharacterBody3D

@onready var health_component: HealthComponent = $HealthComponent

@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $Model/turtle/Skeleton3D/PhysicalBoneSimulator3D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var physical_bone_bone: PhysicalBone3D = $"Model/turtle/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Bone"


@export var death_impulse: float = 10

func _ready() -> void:
	health_component.died.connect(_on_died)
	hurtbox_component.damage_received.connect(_on_damage_recevied)


func _on_died() -> void:
	hitbox_component.set_deferred("monitorable", false)
	hitbox_component.set_deferred("monitoring", false)
	hurtbox_component.set_deferred("monitorable", false)
	hurtbox_component.set_deferred("monitoring", false)
	collision_layer = 0
	physical_bone_simulator_3d.physical_bones_start_simulation()
	

func _on_damage_recevied(_amount: float, source_location: Vector3) -> void:
	if health_component.health == 0:
		physical_bone_bone.apply_central_impulse(source_location.direction_to(global_position) * death_impulse)
