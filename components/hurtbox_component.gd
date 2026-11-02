class_name HurtboxComponent
extends Area3D

signal damage_received(amount: float, source_location: Vector3)

@export var health_component: HealthComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	var hitbox_component: HitboxComponent = area as HitboxComponent
	if hitbox_component and health_component:
		var last_health: float = health_component.health
		health_component.health -= hitbox_component.damage
		hitbox_component.damage_dealt.emit()
		damage_received.emit(last_health - health_component.health, hitbox_component.global_position)
