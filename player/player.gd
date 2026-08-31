class_name Player
extends CharacterBody3D

@export var move_speed: float = 5
@export var jump_speed: float = 7
@export var acceleration: float = 20
@export var mouse_sensitivity: float = 0.05
@export var camera_min_pitch: float = -20
@export var camera_max_pitch: float = 30
@export var bullet_scene: PackedScene


@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var label_3d: Label3D = $Label3D
@onready var input_synchronizer: InputSynchronizer = $InputSynchronizer
@onready var sync_timer: Timer = $SyncTimer
@onready var model: Node3D = $Model
@onready var bullet_spawner: MultiplayerSpawner = $BulletSpawner
@onready var bullet_spawn_marker: Marker3D = $Model/MeshInstance3D2/BulletSpawnMarker
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]


func _ready() -> void:
	animation_tree.active = true
	bullet_spawner.spawn_function = _spawn_bullet
	sync_timer.timeout.connect(_on_sync_timeout)
	var player_data: Statics.PlayerData = Game.instance.get_player(get_multiplayer_authority())
	label_3d.text = player_data.name
	camera_3d.current = is_multiplayer_authority()
	if is_multiplayer_authority():
		sync_timer.start()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		test.rpc()


func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	var mouse_motion: InputEventMouseMotion = event as InputEventMouseMotion
	if  mouse_motion:
		spring_arm_3d.rotation.y -= mouse_motion.relative.x * mouse_sensitivity
		camera_3d.rotation.x = clamp(
			camera_3d.rotation.x - mouse_motion.relative.y * mouse_sensitivity,
			deg_to_rad(camera_min_pitch),
			deg_to_rad(camera_max_pitch)
		)
		

func setup(player_data: Statics.PlayerData) -> void:
	label_3d.text = player_data.name
	set_multiplayer_authority(player_data.id)
	camera_3d.current = is_multiplayer_authority()
	if is_multiplayer_authority():
		sync_timer.start()


@rpc("any_peer")
func test() -> void:
	#var reciver_name: String = Game.get_current_player().name
	Debug.log(name, 10)


func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("fire"):
			_fire()
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if input_synchronizer.jump:
		if is_on_floor():
			velocity.y = jump_speed
		input_synchronizer.jump = false
	
	var move_input: Vector2 = input_synchronizer.move_input
	
	var direction: Vector3 = model.transform.basis * Vector3(move_input.x, 0, move_input.y)
	
	var target: Vector2 = Vector2(direction.x, direction.z) * move_speed
	var current: Vector2 = Vector2(velocity.x, velocity.z)
	var result: Vector2 = current.move_toward(target, acceleration * delta)
	
	velocity.x = result.x
	velocity.z = result.y
	
	move_and_slide()
	
	if not move_input.is_zero_approx():
		model.rotation.y = lerp_angle(
			model.rotation.y,
			spring_arm_3d.rotation.y,
			0.1
		)
	
	# animation
	#if velocity.length_squared() < 2:
		#playback.travel("idle")
	#else:
		#playback.travel("walk")
	animation_tree["parameters/locomotion/blend_position"] = velocity.length()


func _on_sync_timeout() -> void:
	_sync.rpc(global_position, velocity)


@rpc()
func _sync(pos: Vector3, vel: Vector3) -> void:
	global_position = global_position.lerp(pos, 0.5)
	velocity = velocity.lerp(vel, 0.5)


func _fire() -> void:
	bullet_spawner.spawn({
		"pos": bullet_spawn_marker.global_position,
		"rot": bullet_spawn_marker.global_rotation
	})


func _spawn_bullet(data: Dictionary) -> Node:
	if not bullet_scene:
		return null
	var bullet_inst: Node3D = bullet_scene.instantiate()
	bullet_inst.position = data.pos
	bullet_inst.rotation = data.rot
	bullet_inst.set_multiplayer_authority(get_multiplayer_authority())
	return bullet_inst
