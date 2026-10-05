extends GPUParticles3D

func _ready() -> void:
	if not get_parent():
		return
	get_parent().tree_exiting.connect(_on_tree_exiting)


func _on_tree_exiting() -> void:
	var current_transform: Transform3D = transform * get_parent_node_3d().global_transform 
	var tree: SceneTree = get_parent().get_tree()
	get_parent().remove_child(self)
	tree.root.add_child(self)
	global_transform = current_transform
	finished.connect(queue_free)
	emitting = false
